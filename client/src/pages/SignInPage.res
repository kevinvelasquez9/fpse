//input bar for username and password, submit button for moving to the next page

@react.component
let make = () => {
  let (username, setUsername) = React.useState(() => "")
  let (password, setPassword) = React.useState(() => "")

  let handleUsernameChange = event => {
    let value = ReactEvent.Form.currentTarget(event)["value"]
    setUsername(_ => value)
  }

  let handlePasswordChange = event => {
    let value = ReactEvent.Form.currentTarget(event)["value"]
    setPassword(_ => value)
  }

  let signInUser = event => {
    // Update to actually sign in user
    RescriptReactRouter.push("/home")
  }
  
  <div className="bg-frame bg-rose-400 h-screen flex flex-col items-center justify-evenly p-40">
    <input type_="text" value={username} onChange={handleUsernameChange} />
    <input type_="text" value={password} onChange={handlePasswordChange} />
    <button onClick={event => signInUser}>
      {React.string("Sign In")}
    </button>
  </div>
}