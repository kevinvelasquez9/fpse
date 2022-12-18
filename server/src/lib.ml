open Core
open Sqlite3

[@@@warning "-27"]

type str_response = {data: string; code: int} [@@deriving yojson]

type list_response = {data: string list; code: int} [@@deriving yojson]

type bool_response = {data: bool; code: int} [@@deriving yojson]

type url = {user: string; short: string} [@@deriving yojson]

type feed_response = {data: url list; code: int} [@@deriving yojson]

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

let follow (follower : string) (followee : string) : string =
  let sql =
    Printf.sprintf
      "INSERT INTO following (follower, followee) VALUES ('%s', '%s');"
      follower followee
  in
  match execute_sql sql with
  | None ->
      Yojson.Safe.to_string
        (yojson_of_bool_response {data= false; code= 500})
  | Some _ ->
      Yojson.Safe.to_string (yojson_of_bool_response {data= true; code= 200})

let unfollow (follower : string) (followee : string) : string =
  let sql =
    Printf.sprintf
      "DELETE FROM following WHERE follower = '%s' AND followee = '%s';"
      follower followee
  in
  match execute_sql sql with
  | _ ->
      Yojson.Safe.to_string (yojson_of_bool_response {data= true; code= 200})

let get_all_shortened (user : string) : string =
  let empty_response =
    Yojson.Safe.to_string (yojson_of_list_response {data= []; code= 200})
  in
  let sql =
    Printf.sprintf "SELECT * FROM urls WHERE username = '%s';" user
  in
  match execute_sql sql with
  | None -> empty_response
  | Some rows ->
      let urls =
        List.fold rows ~init:[] ~f:(fun acc row ->
            match row with
            | [id; username; full_url; shortened] -> shortened :: acc
            | _ -> acc )
      in
      let json =
        Yojson.Safe.to_string
          (yojson_of_list_response {data= urls; code= 200})
      in
      json

let get_full_url (shortened : string) : string =
  let bad_response =
    Yojson.Safe.to_string (yojson_of_str_response {data= ""; code= 500})
  in
  let sql =
    Printf.sprintf "SELECT full_url FROM urls WHERE shortened = '%s';"
      shortened
  in
  match execute_sql sql with
  | None -> bad_response
  | Some rows ->
      if List.length rows = 0 then bad_response
      else
        let full = List.hd_exn (List.hd_exn rows) in
        let json =
          Yojson.Safe.to_string
            (yojson_of_str_response {data= full; code= 200})
        in
        json

let get_feed (user : string) : string =
  let sql =
    Printf.sprintf
      "SELECT username, shortened FROM urls INNER JOIN following ON \
       urls.username = following.followee WHERE follower = '%s';"
      user
  in
  match execute_sql sql with
  | None ->
      Yojson.Safe.to_string (yojson_of_feed_response {data= []; code= 200})
  | Some rows ->
      let feed =
        List.fold rows ~init:[] ~f:(fun (acc : url list) row ->
            match row with
            | [username; short] -> {user= username; short} :: acc
            | _ -> acc )
      in
      let json =
        Yojson.Safe.to_string
          (yojson_of_feed_response {data= feed; code= 200})
      in
      json

let create_random_short () : string = "foo"

let create_shortened_url (user : string) (full : string) (short : string) :
    string =
  let sql =
    Printf.sprintf
      "INSERT INTO urls (username, full_url, shortened) VALUES ('%s', '%s', \
       '%s');"
      user full short
  in
  match execute_sql sql with
  | None ->
      Yojson.Safe.to_string
        (yojson_of_bool_response {data= false; code= 500})
  | Some _ ->
      Yojson.Safe.to_string (yojson_of_bool_response {data= true; code= 200})

let create_user (username : string) (password : string) : string =
  let sql =
    Printf.sprintf
      "INSERT INTO users (username, password) VALUES ('%s', '%s');" username
      password
  in
  match execute_sql sql with
  | None ->
      Yojson.Safe.to_string
        (yojson_of_bool_response {data= false; code= 500})
  | Some _ ->
      Yojson.Safe.to_string (yojson_of_bool_response {data= true; code= 200})

let validate_user (username : string) (password : string) : string =
  let not_valid_response =
    Yojson.Safe.to_string (yojson_of_bool_response {data= false; code= 500})
  in
  let sql =
    Printf.sprintf
      "SELECT * FROM users WHERE username = '%s' AND password = '%s'"
      username password
  in
  match execute_sql sql with
  | None -> not_valid_response
  | Some rows ->
      if List.length rows = 0 then not_valid_response
      else
        Yojson.Safe.to_string
          (yojson_of_bool_response {data= true; code= 200})
