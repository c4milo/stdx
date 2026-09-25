//! module-graph: build/modules.zig builds exactly the library graph of docs/design.md §3, and no
//! library module receives a package (invariant 14). A module can import only what the build gives
//! it, so this table is the whole of what each codec can reach. The wrappers build on `deflate`
//! and never the reverse, the codecs do not reach one another, and nothing the tools or the
//! benchmarks link (pepegrillo, the oracles, the corpora) is a library module's import.
//!
//! The rule reads two files:
//!   1. `build/modules.zig`. Every `library(b, "<name>", ...)` call creates a module, and every
//!      `<module>.addImport("<name>", ...)` call adds an edge. Both must equal `expected_graph`:
//!      a module or an edge the table lacks is reported where the build writes it, and one the
//!      build lacks is reported at the top of the file.
//!   2. `tools/graph_check.zig`, found beside it at the same prefix. Its `deflate_imports` list is
//!      the import set the check compiles its fixtures against, and it must name exactly the
//!      modules the build gives `deflate`. If the two drift, the check proves something about a
//!      graph stdx does not have.
//!
//! A run that never visits `build/modules.zig` never runs this rule, so `zig build lint` passes it
//! the `build` directory.
//!
//! Both reads follow the parsed tree and the tokens, not values: a module name held in a `const`,
//! or a graph built by a loop, would be invisible. Both files spell their lists out, and the rule
//! requires that they keep doing so.
//!
//! This rule is stdx's own, written against pepegrillo's readers (decision 7).

const std = @import("std");
const Allocator = std.mem.Allocator;
const Ast = std.zig.Ast;
const Node = Ast.Node;
const pepegrillo = @import("pepegrillo");
const ast = pepegrillo.lint.ast;
const paths = pepegrillo.lint.paths;
const report = pepegrillo.lint.report;

pub const name = "module-graph";

/// The file the rule runs on.
pub const build_modules_path = "build/modules.zig";

/// The file read beside it, at the same prefix.
pub const graph_check_path = "tools/graph_check.zig";

/// The function in build/modules.zig that creates and exports one library module.
const library_function = "library";

/// The method call that wires one module into another.
const add_import_method = "addImport";

/// The module whose import set tools/graph_check.zig compiles against.
const checked_module = "deflate";

/// The declaration in tools/graph_check.zig that holds the check's copy of that import set.
const check_list_name = "deflate_imports";

/// The field of a check entry that holds the module name.
const check_name_field = "name";

/// One library module and every module it imports.
pub const Module = struct {
    name: []const u8,
    imports: []const []const u8,
};

/// The graph of docs/design.md §3, with `codec` as decision 11 rules it.
pub const expected_graph = [_]Module{
    .{ .name = "codec", .imports = &.{} },
    .{ .name = "checksum", .imports = &.{} },
    .{ .name = "deflate", .imports = &.{"codec"} },
    .{ .name = "zlib", .imports = &.{ "codec", "checksum", "deflate" } },
    .{ .name = "gzip", .imports = &.{ "codec", "checksum", "deflate" } },
    .{ .name = "zstd", .imports = &.{ "codec", "checksum" } },
    .{ .name = "brotli", .imports = &.{"codec"} },
};

/// Longest path the rule builds for the file it reads beside build/modules.zig.
const max_path_bytes: usize = 4096;

/// The line a finding about a whole file is reported on.
const file_line: usize = 1;

/// What each finding says, one per way the build, the table and the check can disagree.
const messages = struct {
    const module_extra = "build/modules.zig creates \"{s}\", which design §3 does not name" ++
        " (invariant 14)";
    const module_absent = "design §3 names \"{s}\", which build/modules.zig does not create";
    const receiver = "{s} is not a library module; build/modules.zig holds the library graph" ++
        " alone (invariant 14)";
    const edge_extra = "{s} receives \"{s}\", which design §3 does not give it (invariant 14)";
    const edge_absent = "{s} does not receive \"{s}\", which design §3 gives it";
    const check_extra = "{s} names \"{s}\", which build/modules.zig does not give {s}";
    const check_absent = "{s} lacks \"{s}\", which build/modules.zig gives {s}";
};

/// A module name one of the two files spells, with where it was written. `module` is the module
/// the name was given to: empty for a module the build creates, the receiver for an edge.
pub const Entry = struct {
    module: []const u8,
    name: []const u8,
    line: usize,
    column: usize,
};

/// A parsed file the comparison reads.
pub const Source = struct {
    path: []const u8,
    tree: *const Ast,
};

pub fn applies(path: []const u8) bool {
    return paths.ends_with_path(path, build_modules_path);
}

pub fn check(context: *report.Context, file: report.File) !void {
    if (!applies(file.path)) return;
    const tree = file.tree orelse return;
    var path_buffer: [max_path_bytes]u8 = undefined;
    const check_path = try check_path_beside(&path_buffer, file.path);
    const check_source = context.read_file(check_path) orelse {
        return context.findings.add(
            name,
            check_path,
            file_line,
            1,
            "cannot read {s}; its {s} list is what the graph check compiles against (invariant 14)",
            .{ check_path, check_list_name },
        );
    };
    var check_tree = try Ast.parse(context.arena, check_source, .zig);
    defer check_tree.deinit(context.arena);
    if (check_tree.errors.len != 0) {
        const message = "{s} does not parse";
        return context.findings.add(name, check_path, file_line, 1, message, .{check_path});
    }
    try compare(
        context.arena,
        &context.findings,
        .{ .path = file.path, .tree = tree },
        .{ .path = check_path, .tree = &check_tree },
    );
}

/// `<prefix>build/modules.zig` becomes `<prefix>tools/graph_check.zig`, so the rule finds the check
/// whatever the walk's PATH argument was.
pub fn check_path_beside(buffer: []u8, modules_path: []const u8) ![]const u8 {
    const prefix = paths.without_suffix(modules_path, build_modules_path);
    return std.fmt.bufPrint(buffer, "{s}{s}", .{ prefix, graph_check_path });
}

/// Requires the build to create the expected modules with the expected edges, and the check's list
/// to be the build's `deflate` edges.
pub fn compare(arena: Allocator, findings: *report.Findings, build: Source, tool: Source) !void {
    const calls = try collect_calls(arena, build.tree);
    try report_modules(findings, build.path, calls.modules);
    try report_edges(findings, build.path, calls.edges);

    const tool_imports = try collect_tool_imports(arena, tool.tree) orelse {
        return findings.add(
            name,
            tool.path,
            file_line,
            1,
            "{s} declares no {s} list; the check cannot state the graph it proves (invariant 14)",
            .{ tool.path, check_list_name },
        );
    };
    const built = try imports_of(arena, calls.edges, checked_module);
    for (tool_imports) |entry| {
        if (holds(built, entry.name)) continue;
        const arguments = .{ check_list_name, entry.name, checked_module };
        try findings.add(name, tool.path, entry.line, entry.column, messages.check_extra, arguments);
    }
    for (built) |module| {
        if (holds_entry(tool_imports, module)) continue;
        const arguments = .{ check_list_name, module, checked_module };
        try findings.add(name, tool.path, file_line, 1, messages.check_absent, arguments);
    }
}

/// What build/modules.zig creates and wires, each in source order.
pub const Calls = struct {
    modules: []const Entry,
    edges: []const Entry,
};

/// Every `library(b, "<name>", ...)` and every `<module>.addImport("<name>", ...)` call.
pub fn collect_calls(arena: Allocator, tree: *const Ast) !Calls {
    var collector: CallCollector = .{ .tree = tree, .arena = arena };
    for (tree.rootDecls()) |declaration| collector.child(declaration);
    if (collector.failure) |failure| return failure;
    return .{ .modules = collector.modules.items, .edges = collector.edges.items };
}

const CallCollector = struct {
    tree: *const Ast,
    arena: Allocator,
    modules: std.ArrayList(Entry) = .empty,
    edges: std.ArrayList(Entry) = .empty,
    depth: u32 = 0,
    failure: ?anyerror = null,

    pub fn child(self: *CallCollector, node: Node.Index) void {
        self.depth += 1;
        defer self.depth -= 1;
        std.debug.assert(self.depth <= ast.max_tree_depth);
        self.visit(node) catch |failure| {
            self.failure = failure;
        };
        ast.for_each_child(self.tree, node, self);
    }

    fn visit(self: *CallCollector, node: Node.Index) !void {
        if (!ast.is_call(self.tree.nodeTag(node))) return;
        var call_buffer: [1]Node.Index = undefined;
        const call = self.tree.fullCall(&call_buffer, node).?;
        var chain_buffer: [ast.max_chain_bytes]u8 = undefined;
        const chain = ast.chain_text(self.tree, call.ast.fn_expr, &chain_buffer) orelse return;
        if (std.mem.eql(u8, chain, library_function)) {
            // `library(b, "<name>", target, optimize)`: the name is the second argument.
            if (call.ast.params.len < 2) return;
            return self.append(&self.modules, "", call.ast.params[1]);
        }
        if (!std.mem.eql(u8, ast.last_segment(chain), add_import_method)) return;
        if (call.ast.params.len == 0) return;
        const receiver = ast.last_segment(chain[0..chain.len -| (add_import_method.len + 1)]);
        try self.append(&self.edges, receiver, call.ast.params[0]);
    }

    fn append(
        self: *CallCollector,
        list: *std.ArrayList(Entry),
        module: []const u8,
        argument: Node.Index,
    ) !void {
        if (self.tree.nodeTag(argument) != .string_literal) return;
        const quoted = self.tree.tokenSlice(self.tree.nodeMainToken(argument));
        const location = ast.node_start_location(self.tree, argument);
        try list.append(self.arena, .{
            .module = try self.arena.dupe(u8, module),
            .name = try self.arena.dupe(u8, quoted[1 .. quoted.len - 1]),
            .line = location.line,
            .column = location.column,
        });
    }
};

/// Reports a module the build creates and the table lacks, and one the table names and the build
/// never creates.
fn report_modules(findings: *report.Findings, path: []const u8, modules: []const Entry) !void {
    for (modules) |entry| {
        if (expected_module(entry.name) != null) continue;
        try findings.add(name, path, entry.line, entry.column, messages.module_extra, .{entry.name});
    }
    for (expected_graph) |module| {
        if (holds_entry(modules, module.name)) continue;
        try findings.add(name, path, file_line, 1, messages.module_absent, .{module.name});
    }
}

/// Reports an edge the table lacks, and an edge the table holds that the build never adds.
fn report_edges(findings: *report.Findings, path: []const u8, edges: []const Entry) !void {
    for (edges) |entry| {
        const module = expected_module(entry.module) orelse {
            try findings.add(name, path, entry.line, entry.column, messages.receiver, .{entry.module});
            continue;
        };
        if (holds(module.imports, entry.name)) continue;
        const arguments = .{ entry.module, entry.name };
        try findings.add(name, path, entry.line, entry.column, messages.edge_extra, arguments);
    }
    for (expected_graph) |module| {
        for (module.imports) |import| {
            if (holds_edge(edges, module.name, import)) continue;
            const arguments = .{ module.name, import };
            try findings.add(name, path, file_line, 1, messages.edge_absent, arguments);
        }
    }
}

fn expected_module(module_name: []const u8) ?Module {
    for (expected_graph) |module| {
        if (std.mem.eql(u8, module.name, module_name)) return module;
    }
    return null;
}

/// Every `.name = "<name>"` field of the check's `deflate_imports` declaration, in source order, or
/// null when the declaration is absent.
fn collect_tool_imports(arena: Allocator, tree: *const Ast) !?[]const Entry {
    const declaration = find_declaration(tree, check_list_name) orelse return null;
    var entries: std.ArrayList(Entry) = .empty;
    const last = tree.lastToken(declaration);
    var token = tree.firstToken(declaration);
    // Four tokens spell one field: `.` `name` `=` `"codec"`.
    while (token + 3 <= last) : (token += 1) {
        if (!is_name_field(tree, token)) continue;
        const quoted = tree.tokenSlice(token + 3);
        const location = ast.token_location(tree, token + 3);
        try entries.append(arena, .{
            .module = checked_module,
            .name = try arena.dupe(u8, quoted[1 .. quoted.len - 1]),
            .line = location.line,
            .column = location.column,
        });
    }
    return entries.items;
}

/// True when the four tokens starting at `token` spell `.name = "<something>"`.
fn is_name_field(tree: *const Ast, token: Ast.TokenIndex) bool {
    if (tree.tokenTag(token) != .period) return false;
    if (tree.tokenTag(token + 1) != .identifier) return false;
    if (!std.mem.eql(u8, tree.tokenSlice(token + 1), check_name_field)) return false;
    if (tree.tokenTag(token + 2) != .equal) return false;
    return tree.tokenTag(token + 3) == .string_literal;
}

/// The root declaration with this name, or null.
fn find_declaration(tree: *const Ast, wanted: []const u8) ?Node.Index {
    for (tree.rootDecls()) |declaration| {
        if (!is_variable_declaration(tree.nodeTag(declaration))) continue;
        // The main token of a variable declaration is its `const` or `var`; the name follows it.
        const name_token = tree.nodeMainToken(declaration) + 1;
        if (tree.tokenTag(name_token) != .identifier) continue;
        if (std.mem.eql(u8, tree.tokenSlice(name_token), wanted)) return declaration;
    }
    return null;
}

fn is_variable_declaration(tag: Node.Tag) bool {
    return switch (tag) {
        .simple_var_decl, .aligned_var_decl, .local_var_decl, .global_var_decl => true,
        else => false,
    };
}

/// The names the build gives `module`, in source order.
fn imports_of(arena: Allocator, edges: []const Entry, module: []const u8) ![]const []const u8 {
    var list: std.ArrayList([]const u8) = .empty;
    for (edges) |entry| {
        if (std.mem.eql(u8, entry.module, module)) try list.append(arena, entry.name);
    }
    return list.items;
}

fn holds(names: []const []const u8, wanted: []const u8) bool {
    for (names) |candidate| {
        if (std.mem.eql(u8, candidate, wanted)) return true;
    }
    return false;
}

fn holds_entry(entries: []const Entry, wanted: []const u8) bool {
    for (entries) |entry| {
        if (std.mem.eql(u8, entry.name, wanted)) return true;
    }
    return false;
}

fn holds_edge(edges: []const Entry, module: []const u8, import: []const u8) bool {
    for (edges) |entry| {
        const same_module = std.mem.eql(u8, entry.module, module);
        if (same_module and std.mem.eql(u8, entry.name, import)) return true;
    }
    return false;
}

test {
    _ = @import("module_graph_test.zig");
}
