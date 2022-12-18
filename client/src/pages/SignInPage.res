open Endpoints

@react.component
let make = (~setUser, ~setLoggedIn) => {
  let (username, setUsername) = React.useState(() => "")
  let (password, setPassword) = React.useState(() => "")
  let (hasError, setHasError) = React.useState(_ => false)

  let handleUsernameChange = event => {
    let value = ReactEvent.Form.currentTarget(event)["value"]
    setUsername(_ => value)
  }

  let handlePasswordChange = event => {
    let value = ReactEvent.Form.currentTarget(event)["value"]
    setPassword(_ => value)
  }

  let registerUser = _ => {
    open Promise
    let _ = 
      Users.post("http://localhost:8080/user/create", username, password)
        ->then(ret => {
          switch ret {
            | Ok(_) =>
              setHasError(_ => false)
              setLoggedIn(_ => true)
              setUser(_ => username)
              RescriptReactRouter.push("/home")
              resolve()
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
  }

  let logInUser = _ => {
    open Promise
    let _ = 
      Users.post("http://localhost:8080/user/validate", username, password)
        ->then(ret => {
          switch ret {
            | Ok(_) =>
              setHasError(_ => false)
              setLoggedIn(_ => true)
              setUser(_ => username)
              RescriptReactRouter.push("/home")
              resolve()
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
  }
  
  <div className="bg-frame bg-rose-400 h-screen flex flex-col items-center justify-evenly p-40">
    <input type_="text" value={username} onChange={handleUsernameChange} />
    <input type_="text" value={password} onChange={handlePasswordChange} />
    <button onClick={registerUser}>
      {React.string("Register")}
    </button>
    <button onClick={logInUser}>
      {React.string("Sign In")}
    </button>
  </div>
}