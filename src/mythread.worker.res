%%raw(`
const marked = require("marked");
`)

@val external postMessage : string => unit = "postMessage"
@val external marked : string => string = "marked"

let setOnMessage : (_ => unit) => unit = f =>
%raw(` f => {
  onmessage = f;
}`)(f);

/*
setOnMessage(e => {
    Js.Console.log("I got:" ++ e["data"])
    postMessage("I'm here!")
});
*/

setOnMessage(e => {
    Js.Console.log("I got:" ++ e["data"])
    let m = marked(e["data"]);
    Js.Console.log(m)
    postMessage(m);
})


