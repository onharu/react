open RescriptMpst.Mpst


let lens_a = {
  get: ((a, _, _)) => a,
  put: ((_, b, c), a) => (a, b, c),
}
let lens_b = {
  get: ((_, b, _)) => b,
  put: ((a, _, c), b) => (a, b, c),
}
let lens_c = {
  get: ((_, _, c)) => c,
  put: ((a, b, _), c) => (a, b, c),
}


let main = {
  role_label: {closed_match: (#Main(v)) => v, closed_make: v => #Main(v)},
  role_lens: lens_a,
}

let webwork = {
  role_label: {closed_match: (#Webwork(v)) => v, closed_make: v => #Webwork(v)},
  role_lens: lens_b,
}

let carol = {
  role_label: {closed_match: (#Carol(v)) => v, closed_make: v => #Carol(v)},
  role_lens: lens_c,
}


let hello = {
  label_closed: {closed_match: (#hello(v)) => v, closed_make: v => #hello(v)},
  label_open: v => #hello(v),
}

let goodbye = {
  label_closed: {closed_match: (#goodbye(v)) => v, closed_make: v => #goodbye(v)},
  label_open: v => #goodbye(v),
}

let hello_or_goodbye = {
  split: lr => (list{#hello(list_match(x =>
          switch x {
          | #hello(v) => v
          | #goodbye(_) => RescriptMpst.Raw.dontknow()
          }
        , lr))}, list{#goodbye(list_match(x =>
          switch x {
          | #goodbye(v) => v
          | #hello(_) => RescriptMpst.Raw.dontknow()
          }
        , lr))}),
  concat: (l, r) => list{
    #hello(list_match((#hello(v)) => v, l)),
    #goodbye(list_match((#goodbye(v)) => v, r)),
  },
}

let g = \"-->"(main, webwork, hello, \"-->"(webwork, main, goodbye, finish))
