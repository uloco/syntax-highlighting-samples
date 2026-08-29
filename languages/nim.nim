## Module doc comment.
# line comment
#[ block comment ]#
import std/[strformat, strutils]
from std/math import sqrt, PI
export strutils

type
  Color = enum
    red = 0, green = 1, blue = 2
  Meters = distinct float
  Point = tuple[x: int, y: float]
  Shape = ref object of RootObj
    label*: string
    tags: seq[string]
  Node = object
    case kind: Color
    of red: intVal: int64
    of green, blue: strVal: string

const
  Magic = 0xDEAD_BEEF
  Mask = 0b1010_0101
  Perm = 0o644
  Big = 9_000'i64
  Ratio = 1.5e-3

var
  counter = 0
  cache: seq[Point] = @[(x: 1, y: 2.0)]
  flags: set[Color] = {red, blue}

let
  name = "esc\t\"quoted\"\n"
  rawPath = r"C:\no\escape"
  letter: char = '\xFF'
  long = """
triple quoted"""

proc `+`(a, b: Meters): Meters {.inline.} = Meters(a.float + b.float)
proc area*(p: Point; scale: float = 1.0): float {.raises: [].} =
  result = p.x.float * p.y * scale
func pure(x: int): int {.discardable.} = x shl 2 or 1
method render(s: Shape; indent = 2): string {.base.} = &"{s.label:>10}{indent}"
iterator downTo(n: int): int =
  for i in countdown(n, 0, 2): yield i
template twice(body: untyped): untyped = body
macro dumpIt(x: untyped): untyped = x
converter toFloat(m: Meters): float = m.float
proc pick[T](items: openArray[T]; alt: T): T =
  if items.len > 0: items[0] else: alt

proc run() =
  defer: echo "done"
  var total = 0
  when defined(release): total = 1
  elif not defined(js): total = -1
  block outer:
    for i in downTo(6):
      if i == 2: break outer
      total.inc i
  while counter < 3: counter += 1
  let n = Node(kind: red, intVal: Big)
  case n.kind
  of red: echo n.intVal, ' ', Magic, Mask, Perm
  of green: discard
  else: raise newException(ValueError, "bad")
  try:
    discard pick(@[1, 2], 0)
    if total < 0: raise newException(IOError, rawPath)
  except IOError as e: echo "io: ", e.msg
  except CatchableError: echo "other"
  finally: echo fmt"{total} {Ratio:.3f} {flags}"
  let s: Shape = nil
  echo s.isNil, true, sqrt(PI), letter, long, name, cache[0].area(2.0), render(s)
  twice: echo "x"
  pure(3)

run()
