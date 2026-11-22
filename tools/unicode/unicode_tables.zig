//! unicode_tables: writes Unicode 17.0.0's general categories, scripts and simple case folding as
//! the unicode module's tables, or checks the committed file against them (design §8 part 22e).
//!
//! It reads four files of the Unicode Character Database, which tools/unicode/ucd/ holds:
//!
//! - DerivedGeneralCategory.txt: the General_Category of two letters of each code point.
//! - PropertyValueAliases.txt: the names of each General_Category value, LC and the groups of one
//!   letter among them (UAX #44 §5.8.2).
//! - Scripts.txt: the Script of each code point that has one.
//! - CaseFolding.txt: the simple case folding, of statuses C and S (unicode_tables_fold.zig).
//!
//! It gives unicode_tables.zig: each property's ranges, each name of each property as `property`
//! compares it, and the runs of the case orbits.
//!
//! Usage: `unicode_tables [--check] <CaseFolding.txt> <DerivedGeneralCategory.txt>
//! <PropertyValueAliases.txt> <Scripts.txt> <unicode_tables.zig>`
//!
//! Exit status 0 when the file is written, or with `--check` when it equals what the data files
//! give; 1 when a data file cannot be read or parsed, or the file differs; 2 on a usage error.

const std = @import("std");
const parse = @import("unicode_tables_parse.zig");
const fold = @import("unicode_tables_fold.zig");
const Range = parse.Range;

/// The data files, in the order of the command line, each named as its first line names it.
const file_stems = [_][]const u8{ "CaseFolding", "DerivedGeneralCategory", "PropertyValueAliases", "Scripts" };

/// The ranges a line of the generated file holds.
const ranges_per_line = 4;

/// The last code point of ASCII (UTS #18 §1.2.5).
const ascii_max = 0x7F;

/// The exit status of a usage error.
const usage_exit_status = 2;

pub const Error = fold.Error || error{ ValueMissing, NameRepeated };

/// One property: the names that name it, its identifier in the generated file, a line that says
/// what it is, and its ranges.
pub const Property = struct {
    names: []const []const u8,
    identifier: []const u8,
    description: []const u8,
    ranges: []const Range,
};

/// One name, as `property` compares it, and the identifier of the property it names.
const Entry = struct { name: []const u8, identifier: []const u8 };

/// The texts of the data files, in the order of `file_stems`.
pub const Texts = struct {
    case_folding: []const u8,
    categories: []const u8,
    aliases: []const u8,
    scripts: []const u8,
};

/// unicode_tables.zig, from the texts of the four data files.
pub fn tables(arena: std.mem.Allocator, texts: Texts) Error![]u8 {
    var properties: std.ArrayList(Property) = .empty;
    try add_categories(arena, &properties, texts);
    try add_scripts(arena, &properties, texts.scripts);
    try add_derived(arena, &properties, texts.categories);
    return render(arena, properties.items, try fold.runs(arena, texts.case_folding));
}

/// Each General_Category value that PropertyValueAliases.txt names, with all its names.
fn add_categories(arena: std.mem.Allocator, properties: *std.ArrayList(Property), texts: Texts) Error!void {
    const categories = try parse.values(arena, texts.categories);
    var named: usize = 0;
    var lines: parse.Lines = .init(texts.aliases);
    while (try lines.next()) |fields| {
        if (!std.mem.eql(u8, fields[0], "gc")) continue;
        if (fields.len < 3) return error.LineInvalid;
        const short = fields[1];
        const ranges = if (short.len == 2 and !std.mem.eql(u8, short, "LC")) blk: {
            named += 1;
            break :blk categories.get(short) orelse return error.ValueMissing;
        } else try group(arena, categories, short);
        try properties.append(arena, .{
            .names = try arena.dupe([]const u8, fields[1..]),
            .identifier = try std.fmt.allocPrint(arena, "category_{s}", .{try lower(arena, short)}),
            .description = try std.fmt.allocPrint(arena, "General_Category {s}, {s}.", .{ short, fields[2] }),
            .ranges = ranges,
        });
    }
    // Every value DerivedGeneralCategory.txt gives a code point has its names.
    if (named != categories.count()) return error.ValueMissing;
}

/// LC, which is Lu, Ll and Lt, or a group of one letter, which is each value of two letters that
/// starts with it (UAX #44 §5.7.1, Table 12).
fn group(arena: std.mem.Allocator, categories: std.StringArrayHashMapUnmanaged([]Range), short: []const u8) Error![]Range {
    var parts: std.ArrayList([]const Range) = .empty;
    for (categories.keys(), categories.values()) |name, ranges| {
        const holds = if (std.mem.eql(u8, short, "LC"))
            std.mem.eql(u8, name, "Lu") or std.mem.eql(u8, name, "Ll") or std.mem.eql(u8, name, "Lt")
        else
            short.len == 1 and name[0] == short[0];
        if (holds) try parts.append(arena, ranges);
    }
    if (parts.items.len == 0) return error.ValueMissing;
    return parse.union_of(arena, parts.items);
}

/// Each Script value that Scripts.txt gives a code point, named by its long name, in order of it.
fn add_scripts(arena: std.mem.Allocator, properties: *std.ArrayList(Property), text: []const u8) Error!void {
    const scripts = try parse.values(arena, text);
    const names = try arena.dupe([]const u8, scripts.keys());
    std.mem.sort([]const u8, names, {}, name_first);
    for (names) |name| {
        try properties.append(arena, .{
            .names = try arena.dupe([]const u8, &.{name}),
            .identifier = try std.fmt.allocPrint(arena, "script_{s}", .{try lower(arena, name)}),
            .description = try std.fmt.allocPrint(arena, "Script {s}.", .{name}),
            .ranges = scripts.get(name).?,
        });
    }
}

fn name_first(_: void, left: []const u8, right: []const u8) bool {
    return std.mem.order(u8, left, right) == .lt;
}

/// Any, Assigned and ASCII, which UTS #18 §1.2.5 adds to the General_Category values.
fn add_derived(arena: std.mem.Allocator, properties: *std.ArrayList(Property), categories_text: []const u8) Error!void {
    const categories = try parse.values(arena, categories_text);
    const unassigned = categories.get("Cn") orelse return error.ValueMissing;
    const derived = [_]struct { []const u8, []const u8, []const Range }{
        .{ "Any", "Every code point.", &.{.{ .lo = 0, .hi = parse.code_point_max }} },
        .{ "ASCII", "Every code point of ASCII.", &.{.{ .lo = 0, .hi = ascii_max }} },
        .{ "Assigned", "Every code point that is not Cn.", try parse.complement(arena, unassigned) },
    };
    for (derived) |entry| {
        try properties.append(arena, .{
            .names = try arena.dupe([]const u8, &.{entry[0]}),
            .identifier = try lower(arena, entry[0]),
            .description = entry[1],
            .ranges = entry[2],
        });
    }
}

fn lower(arena: std.mem.Allocator, text: []const u8) Error![]u8 {
    return std.ascii.allocLowerString(arena, text);
}

/// A name as `property` compares it: lowercase, without the space, `_` and `-` (UAX #44 §5.9.3,
/// UAX44-LM3, and src/unicode/property.zig).
pub fn normalized(arena: std.mem.Allocator, name: []const u8) Error![]u8 {
    var out: std.ArrayList(u8) = .empty;
    for (name) |octet| {
        if (octet == ' ' or octet == '_' or octet == '-') continue;
        try out.append(arena, std.ascii.toLower(octet));
    }
    return out.items;
}

/// Every name of every property as `property` compares it, in order, each once.
fn entries(arena: std.mem.Allocator, properties: []const Property) Error![]Entry {
    var found: std.ArrayList(Entry) = .empty;
    for (properties) |property| {
        for (property.names) |name| try found.append(arena, .{ .name = try normalized(arena, name), .identifier = property.identifier });
    }
    std.mem.sort(Entry, found.items, {}, entry_first);
    for (found.items[1..], 0..) |entry, index| {
        if (std.mem.eql(u8, entry.name, found.items[index].name)) return error.NameRepeated;
    }
    return found.items;
}

fn entry_first(_: void, left: Entry, right: Entry) bool {
    return std.mem.order(u8, left.name, right.name) == .lt;
}

/// unicode_tables.zig: the tables as Zig source, laid out as `zig fmt` lays them out.
pub fn render(arena: std.mem.Allocator, properties: []const Property, runs: []const fold.Run) Error![]u8 {
    var out: std.Io.Writer.Allocating = .init(arena);
    const named = try entries(arena, properties);
    render_into(&out.writer, properties, named, runs) catch return error.OutOfMemory;
    const source = try arena.dupeZ(u8, out.written());
    const tree = try std.zig.Ast.parse(arena, source, .zig);
    return tree.renderAlloc(arena);
}

fn render_into(writer: *std.Io.Writer, properties: []const Property, named: []const Entry, runs: []const fold.Run) std.Io.Writer.Error!void {
    try writer.print(
        \\//! Unicode {s}'s general categories, scripts and simple case folding, as
        \\//! tools/unicode/unicode_tables.zig writes them from tools/unicode/ucd/. Do not edit this file:
        \\//! `zig build unicode-tables` writes it, and `zig build test` fails when it differs from what
        \\//! the data files give.
        \\
        \\const entries = @import("entries.zig");
        \\const Range = entries.Range;
        \\
        \\/// The version of the Unicode Character Database the tables come from.
        \\pub const version = "{s}";
        \\
        \\/// Each name of each property, as `property` compares it, in order.
        \\pub const properties = [_]entries.Property{{
        \\
    , .{ parse.version, parse.version });
    for (named) |entry| try writer.print("    .{{ .name = \"{s}\", .ranges = &{s} }},\n", .{ entry.name, entry.identifier });
    try writer.writeAll(
        \\};
        \\
        \\/// The runs of the case orbits of CaseFolding.txt's statuses C and S, in order.
        \\pub const fold_runs = [_]entries.FoldRun{
        \\
    );
    for (runs) |run| try render_run(writer, run);
    try writer.writeAll("};\n");
    for (properties) |property| try render_property(writer, property);
}

fn render_run(writer: *std.Io.Writer, run: fold.Run) std.Io.Writer.Error!void {
    try writer.print("    .{{ .lo = 0x{X}, .hi = 0x{X}, .step = ", .{ run.lo, run.hi });
    switch (run.step) {
        .offset => |offset| try writer.print(".{{ .offset = {d} }}", .{offset}),
        .pairs => try writer.writeAll(".pairs"),
    }
    try writer.writeAll(" },\n");
}

fn render_property(writer: *std.Io.Writer, property: Property) std.Io.Writer.Error!void {
    try writer.print("\n/// {s}\nconst {s} = [_]Range{{\n", .{ property.description, property.identifier });
    for (property.ranges, 0..) |range, index| {
        if (index % ranges_per_line == 0) try writer.writeAll("   ");
        try writer.print(" .{{ .lo = 0x{X}, .hi = 0x{X} }},", .{ range.lo, range.hi });
        if (index % ranges_per_line == ranges_per_line - 1 or index == property.ranges.len - 1) try writer.writeAll("\n");
    }
    try writer.writeAll("};\n");
}

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const io = init.io;
    const args = try init.minimal.args.toSlice(arena);
    const check = args.len == file_stems.len + 3 and std.mem.eql(u8, args[1], "--check");
    if (args.len != file_stems.len + 2 and !check) usage();
    const paths = args[args.len - file_stems.len - 1 ..];

    var texts: [file_stems.len][]const u8 = undefined;
    for (file_stems, paths[0..file_stems.len], &texts) |stem, path, *text| {
        text.* = try std.Io.Dir.cwd().readFileAlloc(io, path, arena, .unlimited);
        parse.check_version(text.*, stem) catch fail("{s} is not {s} {s}", .{ path, stem, parse.version });
    }
    const given = tables(arena, .{ .case_folding = texts[0], .categories = texts[1], .aliases = texts[2], .scripts = texts[3] }) catch |err| {
        fail("the data files do not parse: {s}", .{@errorName(err)});
    };
    const output = paths[file_stems.len];
    if (!check) return std.Io.Dir.cwd().writeFile(io, .{ .sub_path = output, .data = given });
    const committed = try std.Io.Dir.cwd().readFileAlloc(io, output, arena, .unlimited);
    if (!std.mem.eql(u8, committed, given)) fail("{s} differs from what the data files give; run `zig build unicode-tables`", .{output});
}

fn fail(comptime format: []const u8, arguments: anytype) noreturn {
    std.debug.print("unicode_tables: " ++ format ++ "\n", arguments);
    std.process.exit(1);
}

fn usage() noreturn {
    std.debug.print("usage: unicode_tables [--check] <CaseFolding.txt> <DerivedGeneralCategory.txt> " ++
        "<PropertyValueAliases.txt> <Scripts.txt> <unicode_tables.zig>\n", .{});
    std.process.exit(usage_exit_status);
}

// Tests.

const testing = std.testing;

const fixture: Texts = .{
    .case_folding = "0041; C; 0061; # LATIN CAPITAL LETTER A\n",
    .categories = "0000..0040 ; Cn\n0041 ; Lu\n0042..0060 ; Cn\n0061 ; Ll\n0062..01C4 ; Cn\n01C5 ; Lt\n" ++
        "01C6..10FFFF ; Cn\n",
    .aliases = "gc ; Cn ; Unassigned\ngc ; LC ; Cased_Letter\ngc ; L ; Letter\ngc ; Ll ; Lowercase_Letter\n" ++
        "gc ; Lt ; Titlecase_Letter\ngc ; Lu ; Uppercase_Letter\nsc ; Latn ; Latin\n",
    .scripts = "0041 ; Latin\n0061 ; Latin\n",
};

test "tables names each property by each of its names, and renders its ranges and the runs" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const text = try tables(arena_state.allocator(), fixture);
    const wanted = [_][]const u8{
        "pub const version = \"17.0.0\";",
        ".{ .name = \"casedletter\", .ranges = &category_lc },",
        ".{ .name = \"lc\", .ranges = &category_lc },",
        ".{ .name = \"uppercaseletter\", .ranges = &category_lu },",
        ".{ .name = \"latin\", .ranges = &script_latin },",
        ".{ .name = \"assigned\", .ranges = &assigned },",
        ".{ .lo = 0x41, .hi = 0x41, .step = .{ .offset = 32 } },",
        "/// General_Category LC, Cased_Letter.\nconst category_lc = [_]Range{\n    .{ .lo = 0x41, .hi = 0x41 }, .{ .lo = 0x61, .hi = 0x61 }, .{ .lo = 0x1C5, .hi = 0x1C5 },\n};",
        "const any = [_]Range{\n    .{ .lo = 0x0, .hi = 0x10FFFF },\n};",
        "const assigned = [_]Range{\n    .{ .lo = 0x41, .hi = 0x41 }, .{ .lo = 0x61, .hi = 0x61 }, .{ .lo = 0x1C5, .hi = 0x1C5 },\n};",
    };
    for (wanted) |line| {
        if (std.mem.indexOf(u8, text, line) == null) {
            std.debug.print("missing: {s}\n", .{line});
            return error.TestUnexpectedResult;
        }
    }
    // A script's code of four letters names no property: the aliases' `sc` lines are not read.
    try testing.expect(std.mem.indexOf(u8, text, "\"latn\"") == null);
}

test "tables refuses a value with no names, and a name two properties share" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    var unnamed = fixture;
    unnamed.aliases = "gc ; Cn ; Unassigned\ngc ; Ll ; Lowercase_Letter\ngc ; Lu ; Uppercase_Letter\n";
    try testing.expectError(error.ValueMissing, tables(arena, unnamed));
    var shared = fixture;
    shared.scripts = "0041 ; Letter\n";
    try testing.expectError(error.NameRepeated, tables(arena, shared));
}

test "normalized drops the space, underscores and hyphens, and lowers each letter" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    try testing.expectEqualStrings("oldturkic", try normalized(arena_state.allocator(), "Old_Turkic"));
    try testing.expectEqualStrings("uppercaseletter", try normalized(arena_state.allocator(), "Upper case-Letter"));
}
