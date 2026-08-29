//! Top-level module doc.
// line comment
const std = @import("std");
const builtin = @import("builtin");

/// Doc comment.
pub const Flags = packed struct(u8) { a: bool = false, b: bool = true, rest: u6 = 0b00_1010 };
pub const Tag = enum(u16) { red = 0xFF, green = 0o17, blue = 1_000 };
pub const Value = union(enum) { int: i64, text: []const u8, none: void };
const Error = error{ OutOfRange, Bad };

pub const Vec = struct {
    const Self = @This();
    x: f32 = 0.0,
    y: f32 = 1.5e3,
    label: ?[]const u8 = null,

    pub fn init(x: f32) Self {
        return .{ .x = x, .y = @as(f32, 2.0) };
    }
    pub fn len(self: *const Self) f32 {
        return @sqrt(self.x * self.x + self.y * self.y);
    }
};

fn clamp(comptime T: type, v: T, lo: T, hi: T) Error!T {
    if (v < lo or v > hi) return Error.OutOfRange;
    return v;
}

fn describe(value: anytype) []const u8 {
    return switch (value) {
        0...9 => "small",
        10, 20 => "round",
        else => "big",
    };
}

pub fn main() !void {
    const gpa = std.heap.page_allocator;
    const buf = try gpa.alloc(u8, 16);
    defer gpa.free(buf);
    errdefer std.debug.print("failed\n", .{});
    var arr = [_]u8{ 'a', '\n', 0x41 };
    const slice: []const u8 = arr[0..2];
    const ptr: *u8 = &arr[0];
    const many: [*]u8 = &arr;
    ptr.* = 'z';
    var maybe: ?u32 = null;
    const got = maybe orelse 7;
    maybe = 9;
    var undef: u64 = undefined;
    undef = @intCast(maybe.?);
    comptime var total: usize = 0;
    inline for (.{ Tag.red, Tag.green }) |t| total += @sizeOf(@TypeOf(t));
    const v = Value{ .text =
        \\multi line
        \\text
    };
    switch (v) {
        .int => |n| std.debug.print("{d}\n", .{n}),
        .text => |s| std.debug.print("{s} {s}\n", .{ s, "esc\t\"q\"" }),
        .none => unreachable,
    }
    const result = clamp(i32, 100, 0, 10) catch |err| blk: {
        std.debug.print("{s}\n", .{@errorName(err)});
        break :blk 0;
    };
    var i: usize = 0;
    outer: while (i < 4) : (i += 1) {
        if (i == 2) break :outer;
    }
    std.debug.print("{d} {d} {any} {s} {}\n", .{ result, got, Flags{}, describe(5), builtin.mode });
    _ = .{ ptr, many, slice, undef, total, Vec.init(1) };
}

test "clamp out of range" {
    try std.testing.expectError(Error.OutOfRange, clamp(u8, 9, 0, 5));
}
