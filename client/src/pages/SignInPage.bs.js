// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as RescriptReactRouter from "@rescript/react/src/RescriptReactRouter.bs.js";

function SignInPage(Props) {
  var match = React.useState(function () {
        return "";
      });
  var setText = match[1];
  var text = match[0];
  var handleInputChange = function ($$event) {
    var value = $$event.currentTarget.value;
    Curry._1(setText, (function (param) {
            return value;
          }));
  };
  return React.createElement("div", {
              className: "bg-frame bg-rose-400 h-screen flex flex-col items-center justify-evenly p-40"
            }, React.createElement("input", {
                  type: "text",
                  value: text,
                  onChange: handleInputChange
                }), React.createElement("input", {
                  type: "text",
                  value: text,
                  onChange: handleInputChange
                }), React.createElement("button", {
                  onClick: (function ($$event) {
                      RescriptReactRouter.push("/home");
                    })
                }, "Sign In"));
}

var make = SignInPage;

export {
  make ,
}
/* react Not a pure module */