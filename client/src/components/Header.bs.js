// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";

function Header(Props) {
  var match = React.useState(function () {
        return "";
      });
  var setText = match[1];
  var handleInputChange = function ($$event) {
    var value = $$event.currentTarget.value;
    Curry._1(setText, (function (param) {
            return value;
          }));
  };
  return React.createElement("div", {
              className: "w-screen h-20 flex flex-row bg-rose-700 justify-between p-6"
            }, React.createElement("div", {
                  className: "text-2xl font-large"
                }, "URL Shortinator"), React.createElement("input", {
                  type: "text",
                  value: match[0],
                  onChange: handleInputChange
                }));
}

var make = Header;

export {
  make ,
}
/* react Not a pure module */
