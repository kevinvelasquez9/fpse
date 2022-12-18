open Types

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

module Users = {
  type res = response<string>

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
