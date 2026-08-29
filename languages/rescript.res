// line comment
/* block comment */
/** doc comment with `code` */

open Belt
module A = Belt.Array

type rec tree<'a> = Leaf | Node(tree<'a>, 'a, tree<'a>)
type point = {x: float, mutable y: float}
type dir = [#up | #down | #left(int)]
type pair = (int, string)

module type Shape = {
  type t
  let area: t => float
}

module Circle: Shape = {
  type t = float
  let area = r => 3.14159 *. r *. r
}

module Unit = {
  include Circle
  let name = "circle"
}

exception NotFound(string)

let hex = 0xFF_FF
let big = 1_000_000
let sci = -1.5e3
let ch = 'a'
let str = "escaped \"quote\"\n"
let tpl = `area: ${Circle.area(2.0)->Float.toString}`
let nothing = ()
let flag = true
let label = if flag { "on" } else { "off" }

let add = (a, b) => a + b
let addF = (a: float, b) => a +. b
let greet = (~name, ~greeting="hi", ()) => `${greeting}, ${name}!`
let (first, second) = (1, "two")

let rec fib = n =>
  switch n {
  | 0 | 1 => n
  | n if n < 0 => raise(NotFound("negative"))
  | _ => fib(n - 1) + fib(n - 2)
  }

let counter = ref(0)
counter := counter.contents + 1

let nums = [1, 2, 3]
let items = list{"a", "b"}
let table = Js.Dict.fromArray([("k", 1)])
let total = nums->A.map(n => n * 2)->A.reduce(0, add)
let shouted = items |> List.map(s => s ++ "!")

let describe = opt =>
  switch opt {
  | Some(#left(n)) when n > 0 => `left ${n->Int.toString}`
  | Some(#up | #down) => "vertical"
  | Some(_) => "other"
  | None => "none"
  }

let safe = () =>
  try fib(-1) catch {
  | NotFound(msg) => Js.log2("failed:", msg)
  | _ => assert(false)
  }

@val external window: {"innerWidth": int} = "window"
@val external fetch: string => promise<Js.Json.t> = "fetch"
@module("path") external join: (string, string) => string = "join"
@send external trim: string => string = "trim"

@deriving(abstract)
type config = {@as("Name") name: string, @optional retries: int}

let width = window["innerWidth"]
let raw: int = %raw(`1 + 1`)
%%raw(`console.log("top level")`)

let load = async url => {
  let json = await fetch(url)
  Js.log(json)
}

@react.component
let make = (~text: string, ~onClick) =>
  <button className="btn" disabled={false} onClick>
    {text->trim->React.string}
  </button>
