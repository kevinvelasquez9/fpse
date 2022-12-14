(* Gracefully execute a SQL command and return a list of string lists *)
val execute_sql : string -> string list list option

(* Execute a non query SQL command *)
val execute_non_query_sql : string -> unit

(* Inititalize the Sqlite tables *)
val init_tables : unit -> unit

(* Drop the URLS table and the FOLLOWERS table *)
val drop_tables : unit -> unit

(* Follow a person *)
val follow : string -> string -> string

(* Unfollow a person *)
val unfollow : string -> string -> string

(* Get all shortened URLs made by user *)
val get_all_shortened : string -> string

(* Get a full URL from a shortened one *)
val get_full_url : string -> string

(* Get a user's feed (URLs made by their following) *)
val get_feed : string -> string

(* Create a shortened URL in the database *)
val create_shortened_url : string -> string -> string -> string

(* Create a user, return false if username is taken *)
val create_user : string -> string -> string

(* Validate a user, return false if username is taken *)
val validate_user : string -> string -> string

(* Check if a user is following someone else *)
val is_following : string -> string -> string

(* Check if user exists *)
val user_exists : string -> string
