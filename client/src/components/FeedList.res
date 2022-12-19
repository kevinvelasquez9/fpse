open Types
open Belt

@react.component
let make = (~feed: array<url>) => {
  let urls = feed -> Array.map(urlObj => {
    <div className="flex flex-row justify-around">
      <div className="bg-gray-400 w-full my-1 py-2 shadow-lg rounded-lg">{React.string(urlObj.user)} </div>
      <button className="bg-cyan-600 w-full my-1 py-2 shadow-lg rounded-lg" onClick={event => RescriptReactRouter.push(`/redirect/${urlObj.short}`)}> {React.string(urlObj.short)}</button>
    </div>
  })
  <div className="bg-gray-900 flex flex-col justify-around">
    <h2 className="text-1xl dark:text-white font-bold text-center"> {React.string("Feed")} </h2>
    {React.array(urls)}
  </div>
}