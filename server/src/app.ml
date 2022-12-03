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
          (* Dream.json ~status:(Dream.int_to_status 200) ~headers "" ) *)
          Dream.html short )

(* Get all shortened URLs associated with this user.
   localhost:8080/user?id=10142022 *)
let get_urls : Dream.route =
  Dream.get "/user" (fun req ->
      match Dream.query req "id" with
      | None -> Dream.json ~status:`Bad_Request ~headers ""
      | Some id -> Dream.json ~status:(Dream.int_to_status 200) ~headers "" )

(* Follow a user *)
(* let follow : Dream.route = Dream.post "/follow" *)

(* Unfollow a user *)
(* let unfollow : Dream.route = Dream.post "/unfollow" *)

let () =
  (* Dream.run @@ Dream.router [welcome; redirect; get_urls; follow;
     unfollow] *)
  Dream.run @@ Dream.router [welcome; redirect; get_urls]
