@react.component
let make = () => {
  let (text, setText) = React.useState(() => "")

  // To be changed to handleSearchChange function
  let handleInputChange = event => {
    let value = ReactEvent.Form.currentTarget(event)["value"]

    setText(_ => value)
  }

  <div className="w-screen h-20 flex flex-row bg-rose-700 justify-between p-6">
    <div
      className="text-2xl font-large">
      {React.string("URL Shortinator")}
    </div>
    <input type_="text" value={text} onChange={handleInputChange} />
  </div>
}