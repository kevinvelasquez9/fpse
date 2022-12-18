@react.component
let make = () => {

  let url = RescriptReactRouter.useUrl()
  let user = ""
  let short = ""

  <div className="w-screen h-screen flex flex-row justify-center">
    <div className="w-frame h-full bg-white">
      <Header />
      {switch url.path {
      | list{} => <SignInPage/>
      | list{"home"} => <HomePage user/>
      | list{"redirect", short} => <Redirect short/>
      | _ => <ErrorPage/>
      }}
    </div>
  </div>
}

