const std = @import("std");
const treez = @import("treez.zig");

pub fn main() !void {
    const ziglang = try treez.Language.get("zig");

    var parser = try treez.Parser.create();
    defer parser.destroy();

    try parser.setLanguage(ziglang);
    parser.useStandardLogger();

    const inp = @embedFile("example.zig");
    const tree = try parser.parseString(null, inp);
    defer tree.destroy();

    const query = try treez.Query.create(ziglang,
        \\(IDENTIFIER) @id
    );
    defer query.destroy();

    const cursor = try treez.Query.Cursor.create();
    defer cursor.destroy();

    cursor.execute(query, tree.getRootNode());

    while (cursor.nextCapture()) |capture| {
        const node = capture.node;
        std.log.info("{s}", .{inp[node.getStartByte()..node.getEndByte()]});
    }
}
