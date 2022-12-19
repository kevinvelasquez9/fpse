@react.component
let make = () => {
  <div className="bg-frame bg-gray-800 h-screen flex items-center justify-center">
      <button onClick={event => RescriptReactRouter.push("/")}>
        {React.string("Go to Sign In Page")}
      </button>
  </div>
}