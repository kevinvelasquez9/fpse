open Belt

@react.component
let make = (~list: array<string>) => {
  let urls = list -> Array.map(url => {
    <button className="bg-gray-400" onClick={event => RescriptReactRouter.push(`/redirect/${url}`)}> {React.string(url)}</button>
  })
  <div>
    {React.array(urls)}
  </div>
}