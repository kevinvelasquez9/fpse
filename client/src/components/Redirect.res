// open Types
open Endpoints

@react.component
let make = (~short: string) => {
  let (full: string, setFull) = React.useState(_ => "")
  // let (loading, setLoading) = React.useState(_ => false)
  let (hasError, setHasError) = React.useState(_ => false)

  React.useEffect0(() => {
    open Promise
    let _ = 
      FullURL.get(`http://localhost:8080/redirect?short=${short}`)
        ->then(ret => {
          switch ret {
            | Ok(fullUrl) =>
              setHasError(_ => false)
              setFull(_ => fullUrl)->resolve
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

  <div className="w-screen h-screen flex flex-row bg-rose-700 justify-between p-6">
    {hasError ? 
      <div
      className="text-2xl font-large">
      {React.string("Error: Nonexistent URL")}
    </div>
    :   
    <a
      className="text-2xl font-large"
      href=full
      target="_blank">
      {React.string(short)}
    </a>
    }
  </div>
}