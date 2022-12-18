@react.component
let make = (~user: string) => {
  let (url, setUrl) = React.useState(() => "")
  let (list, setList) = React.useState(() => "")

  let handleUrlChange = event => {
    let value = ReactEvent.Form.currentTarget(event)["value"]

    setUrl(_ => value)
  }

  //function for getting list of urls from username

  <div className="bg-rose-400 h-screen flex flex-col items-center justify-around p-40">
      <div className="bg-rose-400 flex flex-row">
        <input type_="text" value={text} onChange={handleUrlChange}/>
        <button className="bg-gray-400">
          {React.string("Create Tiny URL")}
        </button>
      </div>
      <UrlList list />
  </div>
}
