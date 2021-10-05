%%raw(`
onmessage = e => {
    console.log("I got:" + e.data)
    postMessage("I'm here!")
}
`)