open Endpoints

@react.component
let make = (~user: string, ~loggedIn: bool) => {
  let (url, setUrl) = React.useState(() => "")
  let (list:array<string>, setList) = React.useState(_ => [])
  let (hasError, setHasError) = React.useState(_ => false)


  React.useEffect0(() => {
    open Promise
    let _ = 
      URLList.get(`http://localhost:8080/user?name=${user}`)
        ->then(ret => {
          switch ret {
            | Ok(urls) =>
              setHasError(_ => false)
              setList(_ => urls)->resolve
            | Error(msg) =>
              setHasError(_ => true)
              reject(FailedRequest("Error: " ++ msg))
          }
        })
        ->catch(e => {
        switch e {
          | FailedRequest(msg) => Js.log("Operation failed! " ++ msg)
          | _ => Js.log("Unknown error")
        }
        resolve()
      })
    None
  })

  let handleUrlChange = event => {
    let value = ReactEvent.Form.currentTarget(event)["value"]

    setUrl(_ => value)
    setList(_ => [])
  }

  <div className="bg-rose-400 h-screen flex flex-col items-center justify-around p-40">
      <div className="bg-rose-400 flex flex-row">
        <input type_="text" value={url} onChange={handleUrlChange}/>
        <button className="bg-gray-400">
          {React.string("Create Tiny URL")}
        </button>
      </div>
      <UrlList list />
  </div>
}
