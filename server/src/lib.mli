(* Gracefully execute a SQL command and return a list of string lists *)
val execute_sql : string -> string list list option

(* Execute a non query SQL command *)
val execute_non_query_sql : string -> unit

(* Inititalize the Sqlite tables *)
val init_tables : unit -> unit

(* Drop the URLS table and the FOLLOWERS table *)
val drop_tables : unit -> unit

(* Follow a person *)
val follow : string -> string -> unit

(* Unfollow a person *)
val unfollow : string -> string -> unit

(* Get all shortened URLs made by user *)
val get_all_shortened : string -> string list list option

(* Get a full URL from a shortened one *)
val get_full_url : string -> string option

(* Get a user's feed (URLs made by their following) *)
val get_feed : string -> string list

(* Create a random short id *)
val create_random_short : unit -> string

(* Create a shortened URL in the database and return the shortened URL *)
val create_shortened_url : string -> string -> string option