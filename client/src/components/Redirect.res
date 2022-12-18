open Types
open Endpoints

@react.component
let make = (~short: string) => {
  let (full: string, setFull) = React.useState(_ => "")
  let (loading, setLoading) = React.useState(_ => false)
  let (hasError, setHasError) = React.useState(_ => false)

  React.useEffect1(() => {
    open Promise
    let _ = 
      FullURL.get(`http://localhost:8080/redirect?short=${short}`)
        ->then(ret => {
          switch ret {
            | Ok(fullUrl) =>
              setHasError(_ => false)
              setFull(_ => fullUrl)->resolve
            | Error(msg) =>
              setHasError(_ => false)
              setFull(_ => msg)->resolve
              // reject(FailedRequest("Error: " ++ msg))
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
  }, ([hasError]))

  <div className="w-screen h-screen flex flex-row bg-rose-700 justify-between p-6">
    <div
      className="text-2xl font-large">
      {hasError ? {React.string("Error")}:{React.string(full)}}
    </div>
  </div>
}