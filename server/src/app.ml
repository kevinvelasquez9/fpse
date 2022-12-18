[@@@warning "-27"]

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
(* Dream.json ~status:(Dream.int_to_status 200) ~headers "" ) *)

(* Get all shortened URLs associated with this user.
   localhost:8080/user?name=user1 *)
let get_urls : Dream.route =
  Dream.get "/user" (fun req ->
      match Dream.query req "name" with
      | None -> Dream.json ~status:`Bad_Request ~headers ""
      | Some name ->
          let urls = Lib.get_all_shortened name in
          Dream.json ~headers urls )

(* Follow a user *)
(* let follow : Dream.route = Dream.post "/follow" *)

(* Unfollow a user *)
(* let unfollow : Dream.route = Dream.post "/unfollow" *)

let () = Dream.run @@ Dream.router [welcome; redirect; get_urls]
(* Dream.run @@ Dream.router [welcome; redirect; get_urls; follow;
   unfollow] *)
(* Dream.run @@ Dream.router [welcome; redirect; get_urls] *)

(* let () = print_endline "OK" *)
