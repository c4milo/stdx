//! brotli_tables: writes RFC 7932's appendices as the brotli module's data, or checks the committed
//! copies against them (design §8 step 12, claim B1).
//!
//! It reads docs/rfcs/rfc7932.txt and gives two files:
//! - dictionary.bin: Appendix A's DICT array, the octets its hexadecimal lines spell.
//! - rfc_tables.zig: Appendix A's NDBITS array, Appendix B's 121 word transformations, and §7.1's
//!   context lookup tables Lut0, Lut1 and Lut2.
//! The brotli module checks each against the length and CRC-32 value the RFC states for it.
//!
//! Usage: `brotli_tables [--check] <rfc7932.txt> <dictionary.bin> <rfc_tables.zig>`
//!
//! Exit status 0 when both files are written, or with `--check` when both equal what the RFC gives;
//! 1 when the RFC cannot be read or parsed, or a checked file differs; 2 on a usage error.

const std = @import("std");

/// The indent of every line of Appendix A's hexadecimal DICT.
const hex_indent_len = 6;

/// The entries of NDBITS: one per word length, 0 to 24 (RFC 7932 §8).
pub const dictionary_bits_count = 25;

/// The entries of each of Lut0, Lut1 and Lut2: one per octet value (RFC 7932 §7.1).
pub const lut_len = 256;

/// The names §7.1 gives its context lookup tables.
const lut_names = [_][]const u8{ "Lut0", "Lut1", "Lut2" };

/// The integers a line of a table holds in the generated file.
const table_row_len = 16;

/// The exit status of a usage error.
const usage_exit_status = 2;

pub const ParseError = error{
    HeadingMissing,
    TableMissing,
    TableInvalid,
    HexInvalid,
    RowInvalid,
    RowOutOfOrder,
    EscapeInvalid,
    KindInvalid,
    OutOfMemory,
};

/// One row of Appendix B: the prefix, the elementary transform's name in the module's `Kind`, and
/// the suffix.
pub const Row = struct {
    prefix: []const u8,
    kind: []const u8,
    suffix: []const u8,
};

/// The text from the line that starts with `start` up to the line that starts with `end`.
pub fn section(text: []const u8, start: []const u8, end: []const u8) ParseError![]const u8 {
    const first = line_starting(text, 0, start) orelse return error.HeadingMissing;
    const last = line_starting(text, first, end) orelse return error.HeadingMissing;
    return text[first..last];
}

fn line_starting(text: []const u8, from: usize, prefix: []const u8) ?usize {
    var position = from;
    var lines = std.mem.splitScalar(u8, text[from..], '\n');
    while (lines.next()) |line| {
        if (std.mem.startsWith(u8, line, prefix)) return position;
        position += line.len + 1;
    }
    return null;
}

/// DICT: the octets of every line of `appendix` that is the indent and nothing but hexadecimal
/// digits, in order. Page headers, footers and prose hold other characters, so none is read.
pub fn dictionary(arena: std.mem.Allocator, appendix: []const u8) ParseError![]u8 {
    var octets: std.ArrayList(u8) = .empty;
    var lines = std.mem.splitScalar(u8, appendix, '\n');
    while (lines.next()) |line| {
        if (!is_hex_line(line)) continue;
        const digits = line[hex_indent_len..];
        if (digits.len % 2 != 0) return error.HexInvalid;
        const start = octets.items.len;
        try octets.resize(arena, start + digits.len / 2);
        _ = std.fmt.hexToBytes(octets.items[start..], digits) catch return error.HexInvalid;
    }
    return octets.items;
}

fn is_hex_line(line: []const u8) bool {
    if (line.len <= hex_indent_len) return false;
    for (line[0..hex_indent_len]) |octet| if (octet != ' ') return false;
    for (line[hex_indent_len..]) |octet| if (!is_lower_hex(octet)) return false;
    return true;
}

fn is_lower_hex(octet: u8) bool {
    return std.ascii.isDigit(octet) or (octet >= 'a' and octet <= 'f');
}

/// The `count` integers after "`name` :=" in `text`, as the RFC lists NDBITS and each Lut. Any other
/// word among them, such as a page's header, fails the parse.
pub fn table(comptime count: usize, text: []const u8, name: []const u8) ParseError![count]u8 {
    var marker_buffer: [16]u8 = undefined;
    const marker = std.fmt.bufPrint(&marker_buffer, "{s} :=", .{name}) catch return error.TableMissing;
    const at = std.mem.indexOf(u8, text, marker) orelse return error.TableMissing;
    var values: [count]u8 = undefined;
    var fields = std.mem.tokenizeAny(u8, text[at + marker.len ..], ", \n");
    for (&values) |*value| {
        const field = fields.next() orelse return error.TableInvalid;
        value.* = std.fmt.parseInt(u8, field, 10) catch return error.TableInvalid;
    }
    return values;
}

/// Appendix B's rows, each a line whose first character past its indent is a digit: the ID, the
/// prefix as a C string, the elementary transform, and the suffix as a C string. The IDs must run
/// from 0 in order.
pub fn rows(arena: std.mem.Allocator, appendix: []const u8) ParseError![]Row {
    var found: std.ArrayList(Row) = .empty;
    var lines = std.mem.splitScalar(u8, appendix, '\n');
    while (lines.next()) |line| {
        const text = std.mem.trimStart(u8, line, " ");
        if (text.len == 0 or !std.ascii.isDigit(text[0])) continue;
        var cursor: Cursor = .{ .text = text };
        const id = cursor.integer() orelse return error.RowInvalid;
        if (id != found.items.len) return error.RowOutOfOrder;
        try found.append(arena, try row(arena, &cursor));
    }
    return found.items;
}

fn row(arena: std.mem.Allocator, cursor: *Cursor) ParseError!Row {
    const prefix = try cursor.c_string(arena);
    const name = cursor.word() orelse return error.RowInvalid;
    const suffix = try cursor.c_string(arena);
    cursor.skip_spaces();
    if (cursor.position != cursor.text.len) return error.RowInvalid;
    return .{ .prefix = prefix, .kind = try kind_of(arena, name), .suffix = suffix };
}

/// The module's `Kind` for an elementary transform's name in RFC 7932 §8: Identity, FermentFirst,
/// FermentAll, OmitFirst1 to OmitFirst9 and OmitLast1 to OmitLast9.
pub fn kind_of(arena: std.mem.Allocator, name: []const u8) ParseError![]const u8 {
    if (std.mem.eql(u8, name, "Identity")) return "identity";
    if (std.mem.eql(u8, name, "FermentFirst")) return "ferment_first";
    if (std.mem.eql(u8, name, "FermentAll")) return "ferment_all";
    const omits = [_]struct { []const u8, []const u8 }{ .{ "OmitFirst", "omit_first_" }, .{ "OmitLast", "omit_last_" } };
    for (omits) |omit| {
        if (!std.mem.startsWith(u8, name, omit[0])) continue;
        const count = name[omit[0].len..];
        if (count.len != 1 or count[0] < '1' or count[0] > '9') return error.KindInvalid;
        return std.fmt.allocPrint(arena, "{s}{s}", .{ omit[1], count });
    }
    return error.KindInvalid;
}

/// A position in one row of Appendix B.
const Cursor = struct {
    text: []const u8,
    position: usize = 0,

    fn skip_spaces(cursor: *Cursor) void {
        while (cursor.position < cursor.text.len and cursor.text[cursor.position] == ' ') cursor.position += 1;
    }

    fn integer(cursor: *Cursor) ?usize {
        cursor.skip_spaces();
        const start = cursor.position;
        while (cursor.position < cursor.text.len and std.ascii.isDigit(cursor.text[cursor.position])) cursor.position += 1;
        return std.fmt.parseInt(usize, cursor.text[start..cursor.position], 10) catch null;
    }

    fn word(cursor: *Cursor) ?[]const u8 {
        cursor.skip_spaces();
        const start = cursor.position;
        while (cursor.position < cursor.text.len and std.ascii.isAlphanumeric(cursor.text[cursor.position])) cursor.position += 1;
        return if (cursor.position == start) null else cursor.text[start..cursor.position];
    }

    /// A string in C's format: quoted, with the escapes Appendix B uses: \" \\ \n \t and \x with
    /// two hexadecimal digits.
    fn c_string(cursor: *Cursor, arena: std.mem.Allocator) ParseError![]const u8 {
        cursor.skip_spaces();
        if (cursor.position == cursor.text.len or cursor.text[cursor.position] != '"') return error.RowInvalid;
        cursor.position += 1;
        var octets: std.ArrayList(u8) = .empty;
        while (cursor.position < cursor.text.len) {
            const octet = cursor.text[cursor.position];
            cursor.position += 1;
            if (octet == '"') return octets.items;
            try octets.append(arena, if (octet == '\\') try cursor.escape() else octet);
        }
        return error.RowInvalid;
    }

    fn escape(cursor: *Cursor) ParseError!u8 {
        if (cursor.position == cursor.text.len) return error.EscapeInvalid;
        const letter = cursor.text[cursor.position];
        cursor.position += 1;
        switch (letter) {
            '"', '\\' => return letter,
            'n' => return '\n',
            't' => return '\t',
            'x' => {
                if (cursor.position + 2 > cursor.text.len) return error.EscapeInvalid;
                const digits = cursor.text[cursor.position..][0..2];
                cursor.position += 2;
                return std.fmt.parseInt(u8, digits, 16) catch error.EscapeInvalid;
            },
            else => return error.EscapeInvalid,
        }
    }
};

/// The tables rfc_tables.zig holds.
pub const Parsed = struct {
    dictionary_bits: [dictionary_bits_count]u8,
    transforms: []const Row,
    luts: [lut_names.len][lut_len]u8,
};

/// rfc_tables.zig: the tables as Zig source, laid out as `zig fmt` lays them out, so the file passes
/// `zig fmt --check` as the tool writes it.
pub fn render(arena: std.mem.Allocator, parsed: Parsed) ParseError![]u8 {
    var out: std.Io.Writer.Allocating = .init(arena);
    render_into(&out.writer, parsed) catch return error.OutOfMemory;
    const source = try arena.dupeZ(u8, out.written());
    const tree = try std.zig.Ast.parse(arena, source, .zig);
    return tree.renderAlloc(arena);
}

fn render_into(writer: *std.Io.Writer, parsed: Parsed) std.Io.Writer.Error!void {
    try writer.writeAll(
        \\//! RFC 7932's NDBITS (Appendix A), word transformations (Appendix B) and context lookup tables
        \\//! (§7.1), as tools/brotli_tables.zig writes them from docs/rfcs/rfc7932.txt. Do not edit this
        \\//! file: `zig build brotli-tables` writes it, and `zig build test` fails when it differs from
        \\//! what the RFC gives. Appendix A's DICT array is dictionary.bin, beside it.
        \\
        \\const Transform = @import("transform.zig").Transform;
        \\
        \\/// NDBITS: log2 of the number of dictionary words of each length, 0 to 24 (RFC 7932 §8).
        \\pub const dictionary_bits = [_]u5{
    );
    for (parsed.dictionary_bits, 0..) |bit_count, index| try writer.print("{s}{d}", .{ if (index == 0) " " else ", ", bit_count });
    try writer.writeAll(
        \\ };
        \\
        \\/// The word transformations in the order of their IDs (RFC 7932 Appendix B).
        \\pub const transforms = [_]Transform{
        \\
    );
    for (parsed.transforms) |transform| {
        try writer.print("    .{{ .prefix = \"{f}\", .kind = .{s}, .suffix = \"{f}\" }},\n", .{
            std.zig.fmtString(transform.prefix),
            transform.kind,
            std.zig.fmtString(transform.suffix),
        });
    }
    try writer.writeAll("};\n");
    for (lut_names, parsed.luts) |name, lut| try render_lut(writer, name, lut);
}

fn render_lut(writer: *std.Io.Writer, name: []const u8, lut: [lut_len]u8) std.Io.Writer.Error!void {
    try writer.print("\n/// {s}, a context ID lookup of the UTF8 and Signed context modes (RFC 7932 §7.1).\n", .{name});
    try writer.print("pub const {c}{s} = [_]u8{{\n", .{ std.ascii.toLower(name[0]), name[1..] });
    for (0..lut_len / table_row_len) |row_index| {
        try writer.writeAll("   ");
        for (lut[row_index * table_row_len ..][0..table_row_len]) |value| try writer.print(" {d},", .{value});
        try writer.writeAll("\n");
    }
    try writer.writeAll("};\n");
}

/// Both files, from the text of RFC 7932.
pub const Tables = struct {
    dictionary: []const u8,
    rfc_tables: []const u8,
};

pub fn tables(arena: std.mem.Allocator, rfc: []const u8) ParseError!Tables {
    const appendix_a = try section(rfc, "Appendix A.", "Appendix B.");
    const appendix_b = try section(rfc, "Appendix B.", "Appendix C.");
    const context_modes = try section(rfc, "7.1.  ", "7.2.  ");
    var parsed: Parsed = .{
        .dictionary_bits = try table(dictionary_bits_count, appendix_a, "NDBITS"),
        .transforms = try rows(arena, appendix_b),
        .luts = undefined,
    };
    for (lut_names, &parsed.luts) |name, *lut| lut.* = try table(lut_len, context_modes, name);
    return .{
        .dictionary = try dictionary(arena, appendix_a),
        .rfc_tables = try render(arena, parsed),
    };
}

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const io = init.io;
    const args = try init.minimal.args.toSlice(arena);
    const check = args.len == 5 and std.mem.eql(u8, args[1], "--check");
    if (args.len != 4 and !check) usage();
    const paths = args[args.len - 3 ..];

    const rfc = try std.Io.Dir.cwd().readFileAlloc(io, paths[0], arena, .unlimited);
    const given = tables(arena, rfc) catch |err| {
        std.debug.print("brotli_tables: {s} does not parse: {s}\n", .{ paths[0], @errorName(err) });
        std.process.exit(1);
    };
    const outputs = [_]struct { []const u8, []const u8 }{
        .{ paths[1], given.dictionary },
        .{ paths[2], given.rfc_tables },
    };
    var differs = false;
    for (outputs) |output| {
        if (!check) {
            try std.Io.Dir.cwd().writeFile(io, .{ .sub_path = output[0], .data = output[1] });
            continue;
        }
        const committed = try std.Io.Dir.cwd().readFileAlloc(io, output[0], arena, .unlimited);
        if (std.mem.eql(u8, committed, output[1])) continue;
        std.debug.print("brotli_tables: {s} differs from what {s} gives; run `zig build brotli-tables`\n", .{ output[0], paths[0] });
        differs = true;
    }
    if (differs) std.process.exit(1);
}

fn usage() noreturn {
    std.debug.print("usage: brotli_tables [--check] <rfc7932.txt> <dictionary.bin> <rfc_tables.zig>\n", .{});
    std.process.exit(usage_exit_status);
}

// Tests.

const testing = std.testing;

test "section takes the text from one heading's line to the next's" {
    const text = "intro\nAppendix A.  Data\n  body\nAppendix B.  More\n";
    try testing.expectEqualStrings("Appendix A.  Data\n  body\n", try section(text, "Appendix A.", "Appendix B."));
    try testing.expectError(error.HeadingMissing, section(text, "Appendix C.", "Appendix D."));
}

test "the dictionary reads the indented hexadecimal lines and nothing else" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const appendix =
        \\Appendix A.  Static Dictionary Data
        \\   The hexadecimal form of the DICT array is the following:
        \\      74696d65
        \\RFC 7932                         Brotli                        July 2016
        \\      646f776e
        \\      NDBITS :=  0,  0
    ;
    try testing.expectEqualStrings("timedown", try dictionary(arena_state.allocator(), appendix));
    try testing.expectError(error.HexInvalid, dictionary(arena_state.allocator(), "      746"));
}

test "a table reads its integers across lines, and refuses a word among them" {
    const appendix =
        \\      NDBITS :=  0,  0,  0,  0, 10, 10, 11, 11, 10, 10,
        \\                10, 10, 10,  9,  9,  8,  7,  7,  8,  7,
        \\                 7,  6,  6,  5,  5
    ;
    const bits = try table(dictionary_bits_count, appendix, "NDBITS");
    try testing.expectEqual(10, bits[4]);
    try testing.expectEqual(5, bits[24]);
    try testing.expectError(error.TableInvalid, table(dictionary_bits_count, "NDBITS := 1, 2", "NDBITS"));
    try testing.expectError(error.TableInvalid, table(3, "Lut0 := 1, 2\nRFC 7932 3", "Lut0"));
    try testing.expectError(error.TableMissing, table(3, "Lut0 := 1, 2, 3", "Lut1"));
}

test "rows read C strings with Appendix B's escapes, in ID order" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    const appendix =
        \\          ID       Prefix     Transform            Suffix
        \\           0           ""     Identity               "\""
        \\           1   "\xc2\xa0"     OmitLast9             "\n\t"
    ;
    const found = try rows(arena, appendix);
    try testing.expectEqual(2, found.len);
    try testing.expectEqualStrings("\"", found[0].suffix);
    try testing.expectEqualStrings("\xc2\xa0", found[1].prefix);
    try testing.expectEqualStrings("omit_last_9", found[1].kind);
    try testing.expectEqualStrings("\n\t", found[1].suffix);
    try testing.expectError(error.RowOutOfOrder, rows(arena, "  1  \"\"  Identity  \"\""));
    try testing.expectError(error.EscapeInvalid, rows(arena, "  0  \"\\q\"  Identity  \"\""));
    try testing.expectError(error.KindInvalid, rows(arena, "  0  \"\"  OmitFirst10  \"\""));
}

test "render writes Zig that holds each field as the RFC gives it" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    var parsed: Parsed = .{
        .dictionary_bits = @splat(1),
        .transforms = &.{.{ .prefix = " ", .kind = "ferment_all", .suffix = "=\"" }},
        .luts = @splat(@splat(0)),
    };
    parsed.luts[2][lut_len - 1] = 7;
    const text = try render(arena_state.allocator(), parsed);
    try testing.expect(std.mem.indexOf(u8, text, "pub const dictionary_bits = [_]u5{ 1, 1,") != null);
    try testing.expect(std.mem.indexOf(u8, text, ".{ .prefix = \" \", .kind = .ferment_all, .suffix = \"=\\\"\" },") != null);
    try testing.expect(std.mem.indexOf(u8, text, "pub const lut2 = [_]u8{\n    0,") != null);
    try testing.expect(std.mem.indexOf(u8, text, " 0, 7,\n};\n") != null);
}
