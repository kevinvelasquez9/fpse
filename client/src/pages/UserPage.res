open Endpoints

@react.component
let make = (~friend: string, ~user: string, ~loggedIn: bool) => {
  let (isFollowing, setIsFollowing) = React.useState(_ => false)
  let (list:array<string>, setList) = React.useState(_ => [])
  let (errorMsg, setErrorMsg) = React.useState(_ => "")
  let (userExists, setUserExists) = React.useState(_ => false)

  let getUrls = _ => {
    open Promise
    let _ = 
      URLList.get(`http://localhost:8080/user?name=${friend}`)
        ->then(ret => {
          switch ret {
            | Ok(urls) =>
              setErrorMsg(_ => "")
              setList(_ => urls)->resolve
            | Error(msg) =>
              setErrorMsg(_ => "Internal Server Error")
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

  let followUser = _ => {
    open Promise 
    let _ = 
      FollowOrUnfollow.post("http://localhost:8080/follow", user, friend)
      ->then(ret => {
          switch ret {
            | Ok(success) =>
              if (success) {
                setErrorMsg(_ => "")
                setIsFollowing(_ => true)
              } else {
                setErrorMsg(_ => "Already Following")
              }
              resolve()
            | Error(msg) =>
              setErrorMsg(_ => "Internal Server Error")
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

  let unFollowUser = _ => {
    open Promise 
    let _ = 
      FollowOrUnfollow.post("http://localhost:8080/unfollow", user, friend)
      ->then(ret => {
          switch ret {
            | Ok(_) =>
              setErrorMsg(_ => "")
              setIsFollowing(_ => false)
              resolve()
            | Error(msg) =>
              setErrorMsg(_ => "Internal Server Error")
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

  let checkIsFollowing = _ => {
    open Promise
    let _ = 
      FollowOrUnfollow.post("http://localhost:8080/isfollowing", user, friend)
      ->then(ret => {
          switch ret {
            | Ok(following) =>
              setErrorMsg(_ => "")
              setIsFollowing(_ => following)
              resolve()
            | Error(msg) =>
              setErrorMsg(_ => "Internal Server Error")
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

  let checkUserExists = _ => {
    open Promise
    let _ = 
      CheckUserExists.get(`http://localhost:8080/user/exists?name=${friend}`)
      ->then(ret => {
          switch ret {
            | Ok(exists) =>
              if (exists) {
                setErrorMsg(_ => "")
                checkIsFollowing()
                getUrls()
              } else {
                setErrorMsg(_ => "User Does Not Exist, Search Another")
              }
              setUserExists(_ => exists)->resolve
            | Error(msg) =>
              setErrorMsg(_ => "Internal Server Error")
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

  let handleFollow = _ => {
    if isFollowing {
      unFollowUser()
    } else {
      followUser()
    }
  }

  React.useEffect1(() => {
    checkUserExists()
    None
  }, [friend])

  <div className="bg-frame bg-gray-800 h-screen flex flex-col items-center justify-evenly p-40">
    {!loggedIn ? 
      <button className="text-2xl font-large dark:text-white w-full my-3 py-2 bg-cyan-600 shadow-lg rounded-lg" onClick={_ => RescriptReactRouter.push("/")}>
            {React.string("Return to Sign In Page")}
      </button> : 
      {userExists ? 
       <>
        <div className="bg-gray-800 flex flex-col justify-center">
          <div className="max-w-[400px] w-full mx-auto bg-gray-900 p-8 px-8 rounded-lg">
            <h2 className="text-4xl dark:text-white font-bold text-center"> {React.string(friend)} </h2>
            <button className="w-full my-3 py-2 bg-cyan-600 shadow-lg rounded-lg" onClick={handleFollow}>
              {isFollowing ? React.string("Unfollow User") : React.string("Follow User")}
            </button>
          </div>
          <div>
          </div>
          <div className="max-w-[400px] w-full mx-auto bg-gray-900 p-8 px-8 rounded-lg">
              <UrlList list />
          </div>
        </div>
        <div className="bg-gray-800">
              <h2 className="text-4xl dark:text-white font-bold text-center"> {React.string(errorMsg)} </h2>
        </div>
      </> 
    : 
      <>
        <div className="bg-gray-800 flex flex-col justify-center">
          <div className="max-w-[400px] w-full mx-auto bg-gray-900 p-8 px-8 rounded-lg">
            <div className="bg-gray-800">
              <h2 className="text-4xl dark:text-white font-bold text-center"> {React.string(friend)} </h2>
              <h2 className="text-4xl dark:text-white font-bold text-center"> {React.string(errorMsg)} </h2>
        </div>
          </div>
        </div>
      </>}
    }
  </div>
}