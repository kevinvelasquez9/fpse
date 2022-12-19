open Types
open Endpoints

@react.component
let make = (~user: string, ~loggedIn: bool) => {
  let (fullUrl, setFullUrl) = React.useState(_ => "")
  let (shortUrl, setShortUrl) = React.useState(_ => "")
  let (list:array<string>, setList) = React.useState(_ => [])
  let (feed:array<url>, setFeed) = React.useState(_ => [])
  let (errorMsg, setErrorMsg) = React.useState(_ => "")

  let getUrls = _ => {
    open Promise
    let _ = 
      URLList.get(`http://localhost:8080/user?name=${user}`)
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

  let getFeedList = _ => {
    open Promise
    let _ =
      GetFeedList.get(`http://localhost:8080/feed?name=${user}`)
        ->then(ret => {
          switch ret {
            |Ok(feedObjects) => 
              setErrorMsg(_ => "")
              setFeed(_ => feedObjects)->resolve
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

  let createShortenedURL = _ => {
    open Promise
    let _ = 
      CreateURL.post("http://localhost:8080/short/create", user, fullUrl, shortUrl)
        ->then(ret => {
          switch ret {
            | Ok(created) =>
              if (created) {
                setErrorMsg(_ => "")
                setFullUrl(_ => "")
                setShortUrl(_ => "")
                getUrls()
              } else {
                setErrorMsg(_ => "Short Link Already in Use")
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

  let handleFullUrlChange = event => {
    let value = ReactEvent.Form.currentTarget(event)["value"]
    setFullUrl(_ => value)
  }

  let handleShortUrlChange = event => {
    let value = ReactEvent.Form.currentTarget(event)["value"]
    setShortUrl(_ => value)
  }

  React.useEffect0(() => {
    getUrls()
    getFeedList()
    None
  })

  <div className="grid grid-cols-1 sm:grid-cols-1 h-screen w-full">
    {!loggedIn ? 
      <div className="bg-gray-800 flex flex-col justify-center">
        <button className=" text-2xl font-large dark:text-white" onClick={_ => RescriptReactRouter.push("/")}>
          {React.string("Return to Sign In Page")}
        </button>
      </div>   : 
      <>
        <div className="bg-gray-800 flex flex-col justify-around">
          <div className="max-w-[400px] w-full mx-auto bg-gray-900 p-8 px-8 rounded-lg">
            <div className="flex flex-col dark:text-white  py-2">
              <label>{React.string("Input Full URL")}</label>
              <input className="rounded-lg bg-gray-700 mt-2 p-2 focus:border-blue-500 focus:bg-gray-800 focus:outline-none" type_="text" value={fullUrl} onChange={handleFullUrlChange} />
            </div>
            <div className="flex flex-col dark:text-white py-2">
              <label>{React.string("Input Short URL")}</label>
              <input className="rounded-lg bg-gray-700 mt-2 p-2 focus:border-blue-500 focus:bg-gray-800 focus:outline-none" type_="text" value={shortUrl} onChange={handleShortUrlChange}/>
            </div>
            <button className="w-full my-3 py-2 bg-cyan-600 shadow-lg rounded-lg" onClick={createShortenedURL}>
              {React.string("Create Shortened URL")}
            </button>
          </div>
          <div className="bg-gray-800 flex flex-row justify-around">
            <div className="max-w-[400px] w-full mx-auto bg-gray-900 p-8 px-8 rounded-lg">
              <UrlList list />
            </div>
            <div className="max-w-[400px] w-full mx-auto bg-gray-900 p-8 px-8 rounded-lg">
              <FeedList feed />
            </div>
          </div>
        </div>
        <div className="bg-gray-800">
            <h2 className="text-4xl dark:text-white font-bold text-center"> {React.string(errorMsg)} </h2>
        </div>
      </>
    }  
  </div>
}

// <div className="bg-gray-800 flex flex-row">
//           <div className="bg-gray-800 flex justify-around flex-col">
//             <input type_="text" placeholder="Input Full URL" value={fullUrl} onChange={handleFullUrlChange}/>
//             <input type_="text" placeholder="Input Short URL" value={shortUrl} onChange={handleShortUrlChange}/>
//           </div>
//           <button className="bg-gray-400" onClick={createShortenedURL}>
//             {React.string("Create Tiny URL")}
//           </button>
//         </div>
//         <div className="bg-gray-800">
//           {React.string(errorMsg)}
//         </div>
//         <div className="bg-gray-800 items-center flex flex-row justify-evenly p-20">
//           <UrlList list />
//           <FeedList feed />
//         </div>