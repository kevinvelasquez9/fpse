// open Types
open Endpoints

@react.component
let make = (~short: string, ~loggedIn: bool) => {
  let (full: string, setFull) = React.useState(_ => "")
  let (errorMsg, setErrorMsg) = React.useState(_ => "")

  React.useEffect0(() => {
    open Promise
    let _ = 
      FullURL.get(`http://localhost:8080/redirect?short=${short}`)
        ->then(ret => {
          switch ret {
            | Ok(fullUrl) =>
              setErrorMsg(_ => "")
              setFull(_ => fullUrl)->resolve
            | Error(msg) =>
              if (msg == "404") {
                setErrorMsg(_ => "Full URL Not Found")
              } else {
                setErrorMsg(_ => "Internal Server Error")
              }
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

  <div className="grid grid-cols-1 sm:grid-cols-1 h-screen w-full">
    <div className="bg-gray-800 flex flex-col justify-center">
      <div className="max-w-[400px] w-full mx-auto bg-gray-900 p-8 px-8 rounded-lg">
        {!loggedIn 
          ? 
          <button className="text-2xl font-large dark:text-white w-full my-3 py-2 bg-cyan-600 shadow-lg rounded-lg" onClick={_ => RescriptReactRouter.push("/")}>
            {React.string("Return to Sign In Page")}
          </button> : 
          <div className="flex flex-col justify-center items-center">
            <div
              className="text-2xl font-large">
              {React.string(errorMsg)}
            </div>  
            <h2 className="text-4xl dark:text-white font-bold text-center"> {React.string("Redirect to Full URL")} </h2>
            <a
              className="text-4xl font-large w-fit my-3 py-2 bg-cyan-600 shadow-lg rounded-lg text-center"
              href=full
              target="_blank">
              {React.string(short)}
            </a>
          </div>
        }
      </div>
    </div>
  </div>
}