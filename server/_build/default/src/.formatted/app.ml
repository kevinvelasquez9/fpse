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
          Dream.json ~status:(Dream.int_to_status 200) ~headers "" )
