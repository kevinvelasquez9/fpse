open Types
open Belt

exception FailedRequest(string)

module Response = {
  type t<'data>
  @send external json: t<'data> => Promise.t<'data> = "json"
}

module FullURL = {
  type res = response<string>

  let params = {
    "method": "GET",
  }

  @val
  external fetch: (string, 'params) => Promise.t<Response.t<res>> = "fetch"

  let get = (url: string) => {
    open Promise
    fetch(url, params)
    ->then(res => Response.json(res))
    ->then(data =>
      switch data.code {
      | 200 => Ok(data.data)
      | _ => Error(Int.toString(data.code))
      }->resolve
    )
    ->catch(e => {
      let msg = switch e {
      | JsError(err) =>
        switch Js.Exn.message(err) {
        | Some(msg) => msg
        | None => ""
        }
      | _ => "Unexpected error occurred"
      }
      Error(msg)->resolve
    })
  }
}

module Users = {
  type res = response<bool>

  @val
  external fetch: (string, 'params) => Promise.t<Response.t<res>> = "fetch"

  let post = (url: string, username: string, password: string) => {
    open Promise
    let params = {"username": username, "password": password}
    let options = {"method": "POST", "body": Js.Json.stringifyAny(params)}
    fetch(url, options)
    ->then(res => Response.json(res))
    ->then(data =>
      switch data.code {
      | 200 => Ok(data.data)
      | _ => Error("URL Not Found")
      }->resolve
    )
    ->catch(e => {
      let msg = switch e {
      | JsError(err) =>
        switch Js.Exn.message(err) {
        | Some(msg) => msg
        | None => ""
        }
      | _ => "Unexpected error occurred"
      }
      Error(msg)->resolve
    })
  }
}

module URLList = {
  type res = response<array<string>>

   let params = {
    "method": "GET",
  }

  @val
  external fetch: (string, 'params) => Promise.t<Response.t<res>> = "fetch"

  let get = (url: string) => {
    open Promise
    fetch(url, params)
    ->then(res => Response.json(res))
    ->then(data =>
      switch data.code {
      | 200 => Ok(data.data)
      | _ => Error("URL Not Found")
      }->resolve
    )
    ->catch(e => {
      let msg = switch e {
      | JsError(err) =>
        switch Js.Exn.message(err) {
        | Some(msg) => msg
        | None => ""
        }
      | _ => "Unexpected error occurred"
      }
      Error(msg)->resolve
    })
  }
}

module CreateURL = {
  type res = response<bool>

  @val
  external fetch: (string, 'params) => Promise.t<Response.t<res>> = "fetch"

  let post = (url: string, user: string, full: string, short: string) => {
    open Promise
    let params = {"user": user, "full": full, "short": short}
    let options = {"method": "POST", "body": Js.Json.stringifyAny(params)}
    fetch(url, options)
    ->then(res => Response.json(res))
    ->then(data =>
      switch data.code {
      | 200 => Ok(data.data)
      | _ => Error("URL Not Found")
      }->resolve
    )
    ->catch(e => {
      let msg = switch e {
      | JsError(err) =>
        switch Js.Exn.message(err) {
        | Some(msg) => msg
        | None => ""
        }
      | _ => "Unexpected error occurred"
      }
      Error(msg)->resolve
    })
  }
}

module GetFeedList = {
  type res = response<array<url>>

   let params = {
    "method": "GET",
  }

  @val
  external fetch: (string, 'params) => Promise.t<Response.t<res>> = "fetch"

  let get = (url: string) => {
    open Promise
    fetch(url, params)
    ->then(res => Response.json(res))
    ->then(data =>
      switch data.code {
      | 200 => Ok(data.data)
      | _ => Error("URL Not Found")
      }->resolve
    )
    ->catch(e => {
      let msg = switch e {
      | JsError(err) =>
        switch Js.Exn.message(err) {
        | Some(msg) => msg
        | None => ""
        }
      | _ => "Unexpected error occurred"
      }
      Error(msg)->resolve
    })
  }
}

module FollowOrUnfollow = {
  type res = response<bool>

  @val
  external fetch: (string, 'params) => Promise.t<Response.t<res>> = "fetch"

  let post = (url: string, follower: string, followee: string) => {
    open Promise
    let params = {"follower": follower, "followee": followee}
    let options = {"method": "POST", "body": Js.Json.stringifyAny(params)}
    fetch(url, options)
    ->then(res => Response.json(res))
    ->then(data =>
      switch data.code {
      | 200 => Ok(data.data)
      | _ => Error("URL Not Found")
      }->resolve
    )
    ->catch(e => {
      let msg = switch e {
      | JsError(err) =>
        switch Js.Exn.message(err) {
        | Some(msg) => msg
        | None => ""
        }
      | _ => "Unexpected error occurred"
      }
      Error(msg)->resolve
    })
  }
}