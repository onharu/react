%%raw(`
import './App.css';
import MyThread from "./mythread.worker.js";
`)

type worker
@send external postMessage : (worker, string) => unit = "postMessage"
@set external setOnMessage : (worker, 'a => unit) => unit = "onmessage"

let startWebWorker : unit => worker = 
  %raw(` () => new MyThread() `) 



let run = _ => {

  let worker = startWebWorker();

  worker->setOnMessage(e => {
    Js.Console.log("Workerから受け取ったもの:" ++ e["data"])
  })
  worker->postMessage("Hello, Worker!!!")


}


@module("./logo.svg") external logo: string = "default"

let hello = _ => {
  print_endline("hello, world!!")
}

@react.component
let make = () => {
  <div className="App">
  <textarea></textarea>
    <header className="App-header">
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
    </header>
  </div>
}

let default = make;

