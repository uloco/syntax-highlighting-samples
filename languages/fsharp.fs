// F# highlight sample
(* block
   comment *)
namespace Demo.Core

open System
open System.Text.RegularExpressions

/// XML doc comment for the module.
module Shapes =
    [<Literal>]
    let Limit = 0xFF
    let mutable counter = 0u
    let inline square (x: 'T) : 'T = x * x
    let (<+>) a b = a + b * 1L
    let compose = square >> string
    let rec sumAll = function [] -> 0 | h :: t -> h + sumAll t
    let mixed = (1, "two\tescaped\n", null, 0o17, 1e-5, 'c')
    type Kind = | Small = 1 | Large = 2
    type Point = { X: float; mutable Y: float }

    [<Obsolete("legacy")>]
    type Shape =
        | Circle of radius: float
        | Rect of w: float * h: float
        | Empty
    type IArea =
        abstract Area: unit -> float
    type Named<'T when 'T :> IComparable>(name: string, value: 'T) =
        let mutable hits = 0
        new() = Named("anon", Unchecked.defaultof<'T>)
        member _.Name = name
        member this.Bump(?step: int) = hits <- hits + defaultArg step 1
        member val Tag = "" with get, set
        static member Zero = Named<int>("zero", 0)
        interface IArea with
            member _.Area() = 0.0

    let areaOf shape =
        match shape with
        | Circle r when r > 0.0 -> Math.PI * square r
        | Rect (w, h) -> w * h
        | Empty -> 0.0
    let describe =
        function
        | Some 0 | Some 1 -> "tiny"
        | Some n -> sprintf "n=%d" n
        | None -> "none"
    let anon = {| Label = "inline"; Count = 3 |}
    let moved p = { p with Y = 1.5m |> float }
    let grid = [| 1.0f; 2.0e-5f |]
    let squares = [ for i in 1 .. 10 do if i % 2 = 0 then yield square i ]
    let lazySeq = seq { yield! squares; yield 0b1010 }
    let fetch (url: string) = async {
        let! child = Async.StartChild(async { return url })
        let! body = child
        return! async { return body.Length }
    }

    let run (args: string[]) =
        let obj = { new IArea with member _.Area() = 1.0 }
        let mutable i = 0
        while i < 3 do i <- i + 1
        for a in args do printfn "%s -> %A" a (Regex.Match(a, @"^\d+$").Success)
        try
            try
                if args.Length = 0 then failwith "empty"
                elif isNull (box obj) then raise (InvalidOperationException())
                else printfn "%s%s" """triple "quoted" """ (describe (Some 2))
            with
            | :? ArgumentException as ex -> eprintfn "%s" ex.Message
            | _ -> reraise ()
        finally
            counter <- counter + 1u

    [<EntryPoint>]
    let main argv =
        [ 1; 2; 3 ] |> List.map (fun x -> int (x <+> 1L)) |> ignore
        do run argv
        0
