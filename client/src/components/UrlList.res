open Belt

@react.component
let make = (~list: array<string>) => {
  let urls = list -> Array.map(url => {
    <li> {React.string(url)} </li>
  })
  <button onClick={event => RescriptReactRouter.push("/whatever")}>
    {React.array(urls)}
  </button>
}