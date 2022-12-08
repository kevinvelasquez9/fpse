open Core
open Sqlite3

[@@@warning "-27"]

let unimplemented _ = failwith "todo"

let db = db_open "database.db"

let execute_sql (sql : string) : string list list option =
  let rows = ref [] in
  let cb (row : string array) =
    let row = row |> Array.to_list in
    rows := !rows @ [row]
  in
  match exec_not_null_no_headers ~cb db sql with
  | Rc.OK -> Some !rows
  | _ -> None

let execute_non_query_sql (sql : string) : unit =
  match execute_sql sql with _ -> ()

let create_users_table () : unit =
  let sql =
    "CREATE TABLE IF NOT EXISTS users ( username TEXT NOT NULL, password \
     TEXT NOT NULL, PRIMARY KEY (username) );"
  in
  execute_non_query_sql sql

let create_urls_table () : unit =
  let sql =
    "CREATE TABLE IF NOT EXISTS urls ( id INTEGER NOT NULL, username TEXT \
     NOT NULL, full_url TEXT NOT NULL, shortened TEXT NOT NULL, PRIMARY KEY \
     (id), FOREIGN KEY (username) REFERENCES users (username) ON DELETE \
     CASCADE );"
  in
  execute_non_query_sql sql

let create_following_table () : unit =
  let sql =
    "CREATE TABLE IF NOT EXISTS following (follower TEXT NOT NULL, followee \
     TEXT NOT NULL, PRIMARY KEY (follower, followee), FOREIGN KEY \
     (follower) REFERENCES users (username) ON DELETE CASCADE, FOREIGN KEY \
     (followee) REFERENCES users (username) ON DELETE CASCADE );"
  in
  execute_non_query_sql sql

let init_tables () : unit =
  execute_non_query_sql "PRAGMA foreign_keys = ON;" ;
  create_users_table () ;
  create_urls_table () ;
  create_following_table ()

let drop_tables () : unit =
  execute_non_query_sql "DROP TABLE IF EXISTS users;" ;
  execute_non_query_sql "DROP TABLE IF EXISTS urls;" ;
  execute_non_query_sql "DROP TABLE IF EXISTS following;"

let follow (follower : string) (followee : string) : unit =
  let sql =
    Printf.sprintf
      "INSERT INTO following (follower, followee) VALUES ('%s', '%s');"
      follower followee
  in
  execute_non_query_sql sql

let unfollow (follower : string) (followee : string) : unit =
  unimplemented ()

let get_all_shortened (user : string) : string list list option =
  let sql =
    Printf.sprintf "SELECT * FROM urls WHERE username = '%s';" user
  in
  execute_sql sql

let get_full_url (shortened : string) : string option =
  let sql =
    Printf.sprintf "SELECT full_url FROM urls WHERE shortened = '%s';"
      shortened
  in
  match execute_sql sql with
  | None -> None
  | Some rows ->
      if List.length rows = 0 then None
      else Some (List.hd_exn (List.hd_exn rows))

let get_feed (user : string) : string list = unimplemented ()

let create_random_short () : string = "foo"

let create_shortened_url (user : string) (full_url : string) : string option
    =
  let shortened = create_random_short () in
  let sql =
    Printf.sprintf
      "INSERT INTO urls (username, full_url, shortened) VALUES ('%s', '%s', \
       '%s');"
      user full_url shortened
  in
  match execute_sql sql with None -> None | Some rows -> Some shortened
