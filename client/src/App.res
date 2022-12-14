@react.component
let make = () => {

  let url = RescriptReactRouter.useUrl()
  let (user: string, setUser) = React.useState(_ => "")
  let (loggedIn: bool, setLoggedIn) = React.useState(_ => false)

  <div className="w-screen h-screen flex flex-row justify-center">
    <div className="w-frame h-full bg-white">
      <Header loggedIn/>
      {switch url.path {
      | list{} => <SignInPage setUser setLoggedIn/>
      | list{"home"} => <HomePage user loggedIn/>
      | list{"redirect", short} => <Redirect short loggedIn/>
      | list{"user", friend} => <UserPage friend user loggedIn/>
      | _ => <ErrorPage/>
      }}
    </div>
  </div>
}

