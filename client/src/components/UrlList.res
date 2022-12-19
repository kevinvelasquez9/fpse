open Belt

@react.component
let make = (~list: array<string>) => {
  let urls = list -> Array.map(url => {
    <button className="bg-cyan-600 w-full my-1 py-2 shadow-lg rounded-lg" onClick={event => RescriptReactRouter.push(`/redirect/${url}`)}> {React.string(url)}</button>
  })
  <div className=" bg-gray-900 flex flex-col justify-around">
    <h2 className="text-1xl dark:text-white font-bold text-center"> {React.string("URLs")} </h2>
    {React.array(urls)}
  </div>
}