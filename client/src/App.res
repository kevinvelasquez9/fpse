@react.component
let make = () => {

  let url = RescriptReactRouter.useUrl()
  let list = ["tim.com", "whatever.com", "fake.com", "google.com", "fpse.com", "winner.com", "finalproject.com", "greatest.com"]

  <div className="w-screen h-screen flex flex-row justify-center">
    <div className="w-frame h-full bg-white">
      <Header />
      {switch url.path {
      | list{} => <SignInPage/>
      | list{"home"} => <HomePage list/>
      | _ => <ErrorPage/>
      }}
    </div>
  </div>
}

