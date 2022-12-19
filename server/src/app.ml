type user_object = {username: string; password: string} [@@deriving yojson]

type follow_object = {follower: string; followee: string} [@@deriving yojson]

type full_url_object = {user: string; short: string; full: string}
[@@deriving yojson]

let headers = [("Access-Control-Allow-Origin", "*")]

(* Welcome page. localhost:8080/ *)
let welcome : Dream.route =
  Dream.get "/" (fun _ -> Dream.html "url-shortener API")

(* Redirect to the associated URL if found, otherwise 404.
   locahost:8080/redirect?short=foobar *)
let redirect : Dream.route =
  Dream.get "/redirect" (fun req ->
      match Dream.query req "short" with
      | None -> Dream.json ~status:`Bad_Request ~headers ""
      | Some short ->
          let full_url = Lib.get_full_url short in
          Dream.json ~headers full_url )

(* Get all shortened URLs associated with this user.
   localhost:8080/user?name=user1 *)
let get_urls : Dream.route =
  Dream.get "/user" (fun req ->
      match Dream.query req "name" with
      | None -> Dream.json ~status:`Bad_Request ~headers ""
      | Some name ->
          let urls = Lib.get_all_shortened name in
          Dream.json ~headers urls )

(* Create a user by posting an object with username and password
   localhost:8080/user/create *)
let create_user : Dream.route =
  Dream.post "/user/create" (fun req ->
      let%lwt body = Dream.body req in
      let user_object =
        body |> Yojson.Safe.from_string |> user_object_of_yojson
      in
      let username = user_object.username in
      let password = user_object.password in
      let valid = Lib.create_user username password in
      Dream.json ~headers valid )

(* Validate user by posting an object with username and password
   localhost:8080/user/validate *)
let validate_user : Dream.route =
  Dream.post "/user/validate" (fun req ->
      let%lwt body = Dream.body req in
      let user_object =
        body |> Yojson.Safe.from_string |> user_object_of_yojson
      in
      let username = user_object.username in
      let password = user_object.password in
      let valid = Lib.validate_user username password in
      Dream.json ~headers valid )

(* Follow a user by posting an object with follower and followee
   localhost:8080/follow *)
let follow : Dream.route =
  Dream.post "/follow" (fun req ->
      let%lwt body = Dream.body req in
      let follow_object =
        body |> Yojson.Safe.from_string |> follow_object_of_yojson
      in
      let follower = follow_object.follower in
      let followee = follow_object.followee in
      let valid = Lib.follow follower followee in
      Dream.json ~headers valid )

(* Unfollow a user by posting an object with follower and followee
   localhost:8080/unfollow *)
let unfollow : Dream.route =
  Dream.post "/unfollow" (fun req ->
      let%lwt body = Dream.body req in
      let follow_object =
        body |> Yojson.Safe.from_string |> follow_object_of_yojson
      in
      let follower = follow_object.follower in
      let followee = follow_object.followee in
      let valid = Lib.unfollow follower followee in
      Dream.json ~headers valid )

(* Get a user's feed with user object localhost:8080/feed?name=user1 *)
let get_feed : Dream.route =
  Dream.get "/feed" (fun req ->
      match Dream.query req "name" with
      | None -> Dream.json ~status:`Bad_Request ~headers ""
      | Some name ->
          let feed = Lib.get_feed name in
          Dream.json ~headers feed )

(* Create a short url by posting a full_url object with user, short, full
   localhost:8080/short/create *)
let create_short : Dream.route =
  Dream.post "/short/create" (fun req ->
      let%lwt body = Dream.body req in
      let full_url_object =
        body |> Yojson.Safe.from_string |> full_url_object_of_yojson
      in
      let user = full_url_object.user in
      let short = full_url_object.short in
      let full = full_url_object.full in
      let valid = Lib.create_shortened_url user full short in
      Dream.json ~headers valid )

(* Check if a user is following someone else by posting object with follower
   and followee localhost:8080/isfollowing*)
let is_following : Dream.route =
  Dream.post "/isfollowing" (fun req ->
      let%lwt body = Dream.body req in
      let follow_object =
        body |> Yojson.Safe.from_string |> follow_object_of_yojson
      in
      let follower = follow_object.follower in
      let followee = follow_object.followee in
      let valid = Lib.is_following follower followee in
      Dream.json ~headers valid )

let () =
  Dream.run
  @@ Dream.router
       [ welcome
       ; redirect
       ; get_urls
       ; create_user
       ; validate_user
       ; follow
       ; unfollow
       ; get_feed
       ; create_short
       ; is_following ]
