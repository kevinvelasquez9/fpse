open OUnit2

type bool_response = {data: bool; code: int} [@@deriving yojson]

type url = {user: string; short: string} [@@deriving yojson]

type feed_response = {data: url list; code: int} [@@deriving yojson]

let test_drop_tables () = Lib.drop_tables ()

let test_init_tables () = Lib.init_tables ()

let test_create_user (username : string) (password : string) : bool =
  let res =
    bool_response_of_yojson
      (Yojson.Safe.from_string (Lib.create_user username password))
  in
  res.data

let test_follow_user (follower : string) (followee : string) : bool =
  let res =
    bool_response_of_yojson
      (Yojson.Safe.from_string (Lib.follow follower followee))
  in
  res.data

let test_is_following (follower : string) (followee : string) : bool =
  let res =
    bool_response_of_yojson
      (Yojson.Safe.from_string (Lib.is_following follower followee))
  in
  res.data

let test_create_url (username : string) (full : string) (short : string) :
    bool =
  let res =
    bool_response_of_yojson
      (Yojson.Safe.from_string
         (Lib.create_shortened_url username full short) )
  in
  res.data

let test_feed (username : string) : int =
  let res =
    feed_response_of_yojson (Yojson.Safe.from_string (Lib.get_feed username))
  in
  List.length res.data

let test_unfollow_user (follower : string) (followee : string) : bool =
  let res =
    bool_response_of_yojson
      (Yojson.Safe.from_string (Lib.unfollow follower followee))
  in
  res.data

let () =
  test_drop_tables () ;
  test_init_tables () ;
  (* create user1 *)
  assert_equal true (test_create_user "user1" "pw1") ;
  (* create user2 *)
  assert_equal true (test_create_user "user2" "pw2") ;
  (* should not be able to create user1 again *)
  assert_equal false (test_create_user "user1" "pw2") ;
  (* user1 follow user2 *)
  assert_equal true (test_follow_user "user1" "user2") ;
  (* user1 is following user2 *)
  assert_equal true (test_is_following "user1" "user2") ;
  (* user2 is not following user1 *)
  assert_equal false (test_is_following "user2" "user1") ;
  (* user2 creates some urls *)
  assert_equal true (test_create_url "user2" "google.com" "goo") ;
  assert_equal true (test_create_url "user2" "yahoo.com" "yah") ;
  (* but a short cannot be reused! *)
  assert_equal false (test_create_url "user2" "bing.com" "goo") ;
  (* user1 should have user2's urls on their feed *)
  assert_equal 2 (test_feed "user1") ;
  (* if user1 unfollows user2, then user1's feed should be empty *)
  assert_equal true (test_unfollow_user "user1" "user2") ;
  assert_equal 0 (test_feed "user1")
