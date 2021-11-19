
%%raw(`
const marked = require("marked");
`)
open RescriptMpst
open MpstWorker.WorkerSide

@val external postMessage : string => unit = "postMessage"
@val external marked : string => string = "marked"

Js.Console.log("start")

/*
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

*/

init(Protocol.g, Protocol.webwork) -> Promise.then(ch => {
  open RescriptMpst.Mpst
  receive(ch, x => #Main(x)) -> Promise.thenResolve((#hello(text, ch)) => {
    let m = marked(text);
    let ch = send(ch, x => #Main(x), x => #goodbye(x), m)
  //Js.Console.log(`My name is : ${m}`)
  close(ch)
  })
})->ignore
