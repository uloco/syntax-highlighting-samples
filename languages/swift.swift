// line comment
/* block comment */
import Foundation
@_exported import Darwin.C

/// Doc comment on the protocol.
@available(macOS 12.0, *)
public protocol Shaped {
    associatedtype Unit: Numeric
    var area: Unit { get set }
    static func unitName() -> String
    mutating func scale(by factor: Unit)
}

typealias Pair = (left: Int, right: Double)
enum Kind: UInt8 { case dot = 0x01, dash = 0b0000_0010 }
enum Node { case leaf(Int?); indirect case nested(Node, tag: String) }
enum Err: Error { case boom(code: Int) }

struct Box<T: Equatable>: Shaped {
    typealias Unit = Int
    static var magic: Int { 0o755 }
    var area: Int = 1_000_000
    private(set) var items: [T] = []
    lazy var cache: [String: Double] = ["pi": 3.141_59, "e": 2.7e0]
    var doubled: Int { area << 1 &+ 0xFF_FF }
    var tracked = 0 {
        willSet { print("will \(newValue)") }
        didSet { print("did \(oldValue)") }
    }
    static func unitName() -> String { #"raw\nliteral"# }
    mutating func scale(by factor: Int) { area *= factor }
    subscript(i: Int) -> T? { items.indices.contains(i) ? items[i] : nil }
}

extension Box: CustomStringConvertible where T: Hashable {
    var description: String { "Box(\(area))" }
    static func + (lhs: Box, rhs: Box) -> Box { Box(area: lhs.area &+ rhs.area) }
}

@objc class Base: NSObject { dynamic func run() throws -> Character { "\u{1F600}" } }

final class Derived: Base {
    override func run() throws -> Character { "\t" }
    class func make(_ n: Int = 3, tags: String..., body: @escaping () -> Void) -> Self? { nil }
}

func measure<T: Shaped>(_ value: T?, label: String = "x") throws -> Pair where T.Unit == Int {
    defer { print("done") }
    guard let v = value, v.area > 0 else { throw Err.boom(code: -1) }
    if let hit = ["a": 1][label] { print(hit) }
    let text = """
        multi \(label) line
        """
    return (left: v.area, right: Double(text.count))
}

@MainActor struct App {
    static func main() async {
        var box = Box<Int>(area: 42)
        let nothing: Int? = nil, sci = 1.5e-3, big: Int64 = 9_223_372
        box.scale(by: 2)
        let list = [1, 2, 3].map { $0 * 2 }.filter { $0 > 2 && !false }
        let any: Any = 0xFF, forced = any as! Int, isInt = any is Int
        Task { try? await Task.sleep(nanoseconds: 1_000) }
        outer: for (i, item) in list.enumerated() where i < 3 {
            switch Node.leaf(item) {
            case .leaf(let n?) where n > 1: print(n)
            case .nested(_, let tag): print(tag)
            default: break outer
            }
        }
        do { _ = try measure(box, label: "a") }
        catch Err.boom(let code) { print("code \(code)") }
        catch { print(error) }
        withUnsafeMutablePointer(to: &box.area) { $0.pointee &-= 1 }
        print(nothing ?? forced, box[0]?.description ?? "-", isInt, sci, big, Box<Int>.magic)
    }
}
