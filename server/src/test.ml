open OUnit2

type url = {user: string; short: string} [@@deriving yojson]

type bool_response = {data: bool; code: int} [@@deriving yojson]

type feed_response = {data: url list; code: int} [@@deriving yojson]

let test_drop_tables _ = Lib.drop_tables ()

let test_init_tables _ = Lib.init_tables ()

let test_create_user _ =
  let res =
    Lib.create_user "user1" "pw1"
    |> Yojson.Safe.from_string |> bool_response_of_yojson
  in
  assert_equal 400 res.code

let table_tests =
  "Table Tests"
  >: test_list ["drop" >:: test_drop_tables; "init" >:: test_init_tables]

let user_tests = "User Tests" >: test_list ["create" >:: test_create_user]

let series = "Server Tests" >::: [user_tests]

let () = Lib.drop_tables () ; Lib.init_tables ()

(* let () = Unix.sleep 2 ; run_test_tt_main series *)
