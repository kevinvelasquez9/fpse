//input bar for username and password, submit button for moving to the next page

@react.component
let make = () => {
  let (text, setText) = React.useState(() => "")

  //To Be Changed with handleUsernameChange and handlePasswordChange functions
  let handleInputChange = event => {
    let value = ReactEvent.Form.currentTarget(event)["value"]

    setText(_ => value)
  }
  
  <div className="bg-frame bg-rose-400 h-screen flex flex-col items-center justify-evenly p-40">
    <input type_="text" value={text} onChange={handleInputChange} />
    <input type_="text" value={text} onChange={handleInputChange} />
    <button onClick={event => RescriptReactRouter.push("/home")}>
      {React.string("Sign In")}
    </button>
  </div>
}