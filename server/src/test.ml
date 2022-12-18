(* using to test functionality for now *)
module L = Lib

let create_user1 =
  "INSERT INTO users (username, password) VALUES ('user1', 'pw1');"

let create_user2 =
  "INSERT INTO users (username, password) VALUES ('user2', 'pw2');"

let () =
  L.drop_tables () ;
  L.init_tables () ;
  L.execute_non_query_sql create_user1 ;
  L.execute_non_query_sql create_user2
(* match L.create_shortened_url "user1" "google.com" with | None ->
   print_endline "none" | Some s -> print_endline s *)
