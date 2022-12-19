open Endpoints

@react.component
let make = (~setUser, ~setLoggedIn) => {
  let (username, setUsername) = React.useState(_ => "")
  let (password, setPassword) = React.useState(_ => "")
  let (errorMsg, setErrorMsg) = React.useState(_ => "")

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
            | Ok(logged) =>
                if (logged) {
                setErrorMsg(_ => "")
                setLoggedIn(_ => logged)
                setUser(_ => username)
                RescriptReactRouter.push("/home")
              } else {
                setErrorMsg(_ => "Username Already Taken")
              }
              resolve()
            | Error(msg) =>
              setErrorMsg(_ => "Username Already Taken")
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
            | Ok(logged) =>
              if (logged) {
                setErrorMsg(_ => "")
                setLoggedIn(_ => logged)
                setUser(_ => username)
                RescriptReactRouter.push("/home")
              } else {
                setErrorMsg(_ => "Incorrect Password")
              }
              resolve()
            | Error(msg) =>
              setErrorMsg(_ => "Incorrect Password")
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
  
  <div className="grid grid-cols-1 sm:grid-cols-1 h-screen w-full">
    <div className="bg-gray-800 flex flex-col justify-center">
      <div className="max-w-[400px] w-full mx-auto bg-gray-900 p-8 px-8 rounded-lg">
        <h2 className="text-4xl dark:text-white font-bold text-center"> {React.string("URL Shortener")} </h2>
        <div className="flex flex-col dark:text-white  py-2">
          <label>{React.string("Username")}</label>
          <input className="rounded-lg bg-gray-700 mt-2 p-2 focus:border-blue-500 focus:bg-gray-800 focus:outline-none" type_="text" value={username} onChange={handleUsernameChange} />
        </div>
        <div className="flex flex-col dark:text-white py-2">
          <label>{React.string("Password")}</label>
          <input className="rounded-lg bg-gray-700 mt-2 p-2 focus:border-blue-500 focus:bg-gray-800 focus:outline-none" type_="text" value={password} onChange={handlePasswordChange} />
        </div>
        <button className="w-full my-3 py-2 bg-cyan-600  shadow-lg rounded-lg" onClick={registerUser}>
          {React.string("Register")}
        </button>
        <button className="w-full my-3 py-2 bg-cyan-600 shadow-lg rounded-lg" onClick={logInUser}>
          {React.string("Sign In")}
        </button>
      </div>
    </div>
    <div className="bg-gray-800">
          <h2 className="text-4xl dark:text-white font-bold text-center"> {React.string(errorMsg)} </h2>
    </div>
  </div>
}