module DB : sig
  (* A PostgreSQL database connection *)
  val conn : Postgresql.connection

  (* Inititalize a URLS table and a FOLLOWERS table *)
  val init_tables : unit -> unit

  (* Drop the URLS table and the FOLLOWERS table *)
  val drop_tables : unit -> unit

  (* Append a row to the URLS table *)
  val append_url :
    user_id:int64 -> url:string -> shortened:string -> num_views:int -> unit

  (* Append a row to the FOLLOWERS table *)
  val append_follower : follower_id:int64 -> followee_id:int64 -> unit
end

(* Follow a person *)
val follow : follower_id:int64 -> followee_id:int64 -> unit

(* Unfollow a person *)
val unfollow : follower_id:int64 -> followee_id:int64 -> unit

(* Get all shortened URLs made by user *)
val get_all_shortened : user_id:int64 -> string list

(* Get a full URL from a shortened one *)
val get_full_url : shortened_url:string -> string

(* Get a user's feed (URLs made by their following) *)
val get_feed : user_id:int64 -> string list

(* Create a shortened URL in the database and return the shortened URL *)
val create_shortened_url : user_id:int64 -> url:string -> string
