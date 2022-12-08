@react.component
let make = (~list: array<string>) => {
  let (text, setText) = React.useState(() => "")

  // To be changed to handleUrlChange function
  let handleInputChange = event => {
    let value = ReactEvent.Form.currentTarget(event)["value"]

    setText(_ => value)
  }

  <div className="bg-rose-400 h-screen flex flex-col items-center justify-around p-40">
      <div className="bg-rose-400 flex flex-row">
        <input type_="text" value={text} onChange={handleInputChange}/>
        <button className="bg-gray-400">
          {React.string("Create Tiny URL")}
        </button>
      </div>
      <UrlList list />
  </div>
}
