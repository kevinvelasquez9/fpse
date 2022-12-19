@react.component
let make = (~loggedIn: bool) => {
  let (text, setText) = React.useState(() => "")

  let handleInputChange = event => {
    let value = ReactEvent.Form.currentTarget(event)["value"]
    setText(_ => value)
  }

  let handleSearch = _ => {
    RescriptReactRouter.push(`/user/${text}`)
  }

  <div className="w-screen h-20 flex flex-row bg-gray-500 justify-between p-6">
    {loggedIn ? 
      <>
        <button
          className="text-4xl font-bold font-large dark:text-white"
          onClick={_ => RescriptReactRouter.push("/home")}>
          {React.string("URL Shortener")}
        </button>
        <div className="flex flex-row">
          <input className="shadow-lg rounded-lg" type_="text" value={text} onChange={handleInputChange} /> 
          <button className="bg-cyan-600 shadow-lg rounded-lg" onClick={handleSearch}>
            {React.string("Search")}
          </button>
        </div>
      </>: <></>}
  </div>
}