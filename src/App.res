%%raw(`
import './App.css';
import MyThread from "./mythread.worker.js";
`)

open Webapi.Dom
open Document
//open Element
open HtmlInputElement
open Belt.Option

open RescriptMpst.WebWorker.MainSide

type worker
external unsafeAsHtmlInputElement: Element.t => HtmlInputElement.t = "%identity"
@send external postMessage : (worker, string) => unit = "postMessage"
@set external setOnMessage : (worker, 'a => unit) => unit = "onmessage"

//let startWebWorker : unit => worker = 
  //%raw(` () => new MyThread() `) 

//option -> string
let unsafeUnwrap = e =>
  switch e {
    | Some(v) => v
    | None => failwith("error!")
  }

let transform = _ => {
  open RescriptMpst.Mpst
  let txtelt = document -> getElementById("txt")
  let text = txtelt -> map(unsafeAsHtmlInputElement) -> map(value)  
  let text = Belt.Option.getExn(text)
  let content = document -> getElementById("content")
  let worker = newWorker(%raw(`new MyThread()`))

  /*let f = e => {
        switch content -> map(Element.setInnerHTML) {
          | Some(f) => f((e["data"]))
          | None => ()
        }
      }
*/

  let ch = RescriptMpst.MpstWorker.MainSide.initWorkers(Protocol.g, Protocol.main, [("Webwork", worker)])  

  let ch = send(ch, x => #Webwork(x), x => #hello(x), text)
  receive(ch, x => #Webwork(x))
  ->Promise.thenResolve((#goodbye(v,ch)) => {
      Js.Console.log(`main: I got: ${v}`)
      Belt.Option.getExn(content) -> Element.setInnerHTML(v)
      close(ch)
  })->ignore
  //worker -> setOnMessage(f)
  //worker -> postMessage(unsafeUnwrap(text))
}
/*<javascript>version
let transform : _ => unit = e => 
%raw(`
  () => {
    let txtelt = document.getElementById("txt");
    let text = txtelt.value;
    let content = document.getElementById("content");
    let worker = new MyThread();
    let f = e => {
      content.innerHTML = e["data"];
      }
    worker.onmessage = f;
    worker.postMessage(text)
  }`
  )(e)
*/



let run = 
 %raw(//<javascript>version
` () => {
  let worker = new MyThread();
  let f = e => {
    console.log("Worker から受け取ったもの:" + e["data"])
  };
  worker.onmessage = f;
  worker.postMessage("Hello, Worker!!!");
}
`)
/*<rescript>version
  _ => {
  let worker = startWebWorker();
  let f = e => {
    Js.Console.log("Workerから受け取ったもの:" ++ e["data"])
  };
  worker->setOnMessage(f)
  worker->postMessage("Hello, Worker!!!")
}
*/


@module("./logo.svg") external logo: string = "default"

let hello : _ => unit = _ => {
  print_endline("hello, world!!")
}

@react.component
let make = () => {
  <div className="App">
  //<button onClick={transform}> {React.string("markdown")}</button>
  <textarea id="txt" cols=130 rows=25 onKeyUp={transform}></textarea>
  <div id="content"></div>
  
  

    /*<header className="App-header">
      <img src={logo} className="App-logo" alt="logo" />
      <p>
        {React.string("Edit ")}
        <code> {React.string("src/App.js")} </code>
        {React.string(" and save to reload.")}
      </p>
      <a className="App-link" onClick={run} 
      target="_blank" rel="noopener noreferrer">
       {React.string("Learn React")}
      </a>
    </header>*/
  </div>
}

let default = make;

/* (webworkerなしでのmarkdown)
let transform : _ => unit = e => 
%raw(`
  () => {
    let txtelt = document.getElementById("txt");
    let text = txtelt.value;
    let content = document.getElementById("content");
    content.innerHTML = marked(text);
    console.log(text);
  }`
  )(e)
  */

   //・webworkerゲーム（slack参照）メインスレッドだけをまずやる