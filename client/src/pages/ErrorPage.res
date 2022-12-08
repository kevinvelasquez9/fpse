@react.component
let make = () => {
  <div className="bg-frame bg-rose-400 h-screen flex items-center justify-center">
      <button onClick={event => RescriptReactRouter.push("/home")}>
        {React.string("Go to Home Page")}
      </button>
  </div>
}