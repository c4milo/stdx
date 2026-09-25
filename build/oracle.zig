//! The oracles and the corpora of design §8 step 2, wired for `tools/` and `bench/` only.
//!
//! - `zig build oracle-selftest -Doracles` runs `tools/oracle/selftest.zig` over every corpus file:
//!   zlib and Wuffs must decode every stream zlib encodes, at every level and strategy in all three
//!   containers, to the same octets.
//! - `zig build corpus -Doracles` cuts the HTTP-shaped payloads into their three sizes and installs
//!   them, with every other corpus file, under `zig-out/corpus/`.
//! - `zig build test-oracle -Doracles` runs the tests of the oracle bindings and the self-test.
//! - `zig build bench-deflate -Doracles` times DEFLATE decoding and encoding over the corpora
//!   (`bench/deflate/deflate.zig`).
//!
//! The oracles and the corpora are lazy packages (decisions 8 and 15), fetched only when a build
//! passes `-Doracles`, so `zig build test` on a fresh clone downloads none of their 260 MB. A step
//! run without the option fails and says so. None of this reaches a library module: the modules
//! are built in build/modules.zig, and `zig build graph-check` shows `deflate` cannot import
//! `oracle` (invariant 14).
const std = @import("std");

/// The zlib sources the oracle compiles: the library without its gz* file layer, which would need
/// the host's file I/O.
const zlib_sources = [_][]const u8{
    "adler32.c", "compress.c", "crc32.c", "deflate.c", "infback.c", "inffast.c",
    "inflate.c", "inftrees.c", "trees.c", "uncompr.c", "zutil.c",
};

/// The directory of the Wuffs package that holds `wuffs-v0.4.c`.
const wuffs_directory = "release/c";

/// The Silesia corpus, one file per name, at the top of its package.
const silesia_files = [_][]const u8{
    "dickens", "mozilla", "mr",  "nci",     "ooffice", "osdb",
    "reymont", "samba",   "sao", "webster", "x-ray",   "xml",
};

/// The Canterbury corpus proper, at the top of its package.
const canterbury_files = [_][]const u8{
    "alice29.txt", "asyoulik.txt", "cp.html", "fields.c", "grammar.lsp", "kennedy.xls",
    "lcet10.txt",  "plrabn12.txt", "ptt5",    "sum",      "xargs.1",
};

/// The Canterbury large corpus, at the top of its package.
const canterbury_large_files = [_][]const u8{ "E.coli", "bible.txt", "world192.txt" };

/// The WHATWG HTML Standard's single page, at an immutable commit snapshot, pinned by SHA-256
/// (decision 15). Zig fetches archives only, so tools/corpus/fetch.sh fetches this one.
const whatwg_url = "https://html.spec.whatwg.org/commit-snapshots/2f441941fc523877bd9d5cd7de3b91a81a00ca2e/";
const whatwg_sha256 = "39e9c90cb0db0df841de36867ea8cef139ad535d8fe47b3d0dd35eb38f291dd1";

/// The suffixes of the pieces tools/corpus/cut.zig writes for each HTTP kind.
const piece_suffixes = [_][]const u8{ "1k", "16k", "1m" };

/// The message a step prints when the build was not given `-Doracles`.
const disabled_message = "pass -Doracles: the oracles and the corpora are lazy packages this build " ++
    "fetches only when asked (decisions 8 and 15)";

pub const Options = struct {
    /// Whether the build was given `-Doracles`.
    enabled: bool,
};

pub fn add(b: *std.Build, options: Options) void {
    const selftest_step = b.step("oracle-selftest", "Require zlib and Wuffs to agree over the corpora (-Doracles)");
    const corpus_step = b.step("corpus", "Cut the HTTP payloads and install every corpus file (-Doracles)");
    const test_step = b.step("test-oracle", "Run the tests of the oracle bindings and the self-test (-Doracles)");
    const bench_step = b.step("bench-deflate", "Time DEFLATE decoding and encoding over the corpora (-Doracles)");
    if (!options.enabled) {
        const fail = b.addFail(disabled_message);
        inline for (.{ selftest_step, corpus_step, test_step, bench_step }) |step| step.dependOn(&fail.step);
        return;
    }
    const oracle = add_oracle_module(b) orelse return;
    const corpus = add_corpus(b) orelse return;

    const selftest_module = host_module(b, "tools/oracle/selftest.zig");
    selftest_module.addImport("oracle", oracle);
    const selftest = b.addExecutable(.{ .name = "oracle_selftest", .root_module = selftest_module });
    const run = b.addRunArtifact(selftest);
    add_corpus_args(b, run, corpus);
    selftest_step.dependOn(&run.step);

    const bench_module = b.createModule(.{
        .root_source_file = b.path("bench/deflate/deflate.zig"),
        .target = b.graph.host,
        .optimize = .ReleaseSafe,
    });
    bench_module.addImport("oracle", oracle);
    const bench = b.addExecutable(.{ .name = "bench_deflate", .root_module = bench_module });
    b.installArtifact(bench);
    const bench_run = b.addRunArtifact(bench);
    bench_run.has_side_effects = true;
    add_corpus_args(b, bench_run, corpus);
    bench_step.dependOn(&bench_run.step);

    const install = b.addInstallDirectory(.{
        .source_dir = corpus.pieces,
        .install_dir = .prefix,
        .install_subdir = "corpus",
    });
    corpus_step.dependOn(&install.step);

    inline for (.{ oracle, selftest_module, bench_module }) |module| {
        const tests = b.addTest(.{ .root_module = module });
        test_step.dependOn(&b.addRunArtifact(tests).step);
    }
}

/// Passes every corpus file to `run` as `<name>=<path>`.
fn add_corpus_args(b: *std.Build, run: *std.Build.Step.Run, corpus: Corpus) void {
    for (corpus.files) |file| run.addPrefixedFileArg(b.fmt("{s}=", .{file.name}), file.path);
}

/// The `oracle` module: tools/oracle/oracle.zig over zlib and Wuffs, compiled for the host. The C
/// is built ReleaseFast: it is the oracles' code, not stdx's, and it runs over hundreds of
/// megabytes. Null until the packages are fetched.
fn add_oracle_module(b: *std.Build) ?*std.Build.Module {
    const zlib = b.lazyDependency("madler_zlib", .{}) orelse return null;
    const wuffs = b.lazyDependency("wuffs", .{}) orelse return null;
    const library = b.addLibrary(.{
        .name = "oracle_c",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = b.graph.host,
            .optimize = .ReleaseFast,
            .link_libc = true,
        }),
    });
    library.root_module.addIncludePath(zlib.path(""));
    library.root_module.addIncludePath(wuffs.path(wuffs_directory));
    library.root_module.addCSourceFiles(.{ .root = zlib.path(""), .files = &zlib_sources });
    library.root_module.addCSourceFile(.{ .file = b.path("tools/oracle/oracle.c") });
    const module = host_module(b, "tools/oracle/oracle.zig");
    module.link_libc = true;
    module.linkLibrary(library);
    return module;
}

/// One corpus file the self-test reads.
const File = struct {
    name: []const u8,
    path: std.Build.LazyPath,
};

const Corpus = struct {
    /// Every file, the cut HTTP pieces included.
    files: []const File,
    /// The directory holding the cut pieces and a copy of every other file.
    pieces: std.Build.LazyPath,
};

/// Every corpus file of decision 15, with the HTTP payloads cut to their three sizes. Null until
/// the packages are fetched.
fn add_corpus(b: *std.Build) ?Corpus {
    const silesia = b.lazyDependency("silesia", .{}) orelse return null;
    const canterbury = b.lazyDependency("canterbury", .{}) orelse return null;
    const canterbury_large = b.lazyDependency("canterbury_large", .{}) orelse return null;
    const three = b.lazyDependency("three", .{}) orelse return null;
    const bootstrap = b.lazyDependency("bootstrap", .{}) orelse return null;
    const cldr_core = b.lazyDependency("cldr_core", .{}) orelse return null;

    var gathering: Gathering = .{ .b = b, .copies = b.addWriteFiles() };
    gathering.add_package("silesia", silesia, &silesia_files);
    gathering.add_package("canterbury", canterbury, &canterbury_files);
    gathering.add_package("canterbury-large", canterbury_large, &canterbury_large_files);

    const cut = b.addExecutable(.{ .name = "corpus_cut", .root_module = host_module(b, "tools/corpus/cut.zig") });
    const fetch = b.addSystemCommand(&.{ "bash", "tools/corpus/fetch.sh", whatwg_url, whatwg_sha256 });
    fetch.addFileInput(b.path("tools/corpus/fetch.sh"));
    const whatwg = fetch.addOutputFileArg("whatwg.html");

    gathering.add_pieces(cut, "html", &.{whatwg}, null);
    gathering.add_pieces(cut, "json", &.{cldr_core.path("supplemental")}, ".json");
    gathering.add_pieces(cut, "js", &.{ three.path("build/three.core.js"), three.path("build/three.module.js") }, null);
    gathering.add_pieces(cut, "css", &.{
        bootstrap.path("dist/css/bootstrap.css"),
        bootstrap.path("dist/css/bootstrap-grid.css"),
        bootstrap.path("dist/css/bootstrap-utilities.css"),
        bootstrap.path("dist/css/bootstrap-reboot.css"),
    }, null);
    return .{ .files = gathering.files.items, .pieces = gathering.copies.getDirectory() };
}

/// The corpus files as they are added: the list the self-test reads, and a directory holding a
/// copy of each.
const Gathering = struct {
    b: *std.Build,
    copies: *std.Build.Step.WriteFile,
    files: std.ArrayList(File) = .empty,

    fn add(self: *Gathering, label: []const u8, path: std.Build.LazyPath) void {
        self.files.append(self.b.allocator, .{ .name = label, .path = path }) catch @panic("OOM");
        _ = self.copies.addCopyFile(path, label);
    }

    /// Every named file at the top of a package, labelled `<corpus>/<name>`.
    fn add_package(self: *Gathering, corpus: []const u8, package: *std.Build.Dependency, names: []const []const u8) void {
        for (names) |name| self.add(self.b.fmt("{s}/{s}", .{ corpus, name }), package.path(name));
    }

    /// The three pieces tools/corpus/cut.zig cuts from `sources`, labelled `http/<kind>-<size>`.
    /// With an `extension`, each source is a directory the tool walks for files ending in it.
    fn add_pieces(
        self: *Gathering,
        cut: *std.Build.Step.Compile,
        kind: []const u8,
        sources: []const std.Build.LazyPath,
        extension: ?[]const u8,
    ) void {
        const b = self.b;
        const run = b.addRunArtifact(cut);
        const directory = run.addOutputDirectoryArg(kind);
        run.addArg(kind);
        if (extension) |suffix| run.addArgs(&.{ "--extension", suffix });
        for (sources) |source| {
            if (extension != null) run.addDirectoryArg(source) else run.addFileArg(source);
        }
        for (piece_suffixes) |suffix| {
            const name = b.fmt("{s}-{s}", .{ kind, suffix });
            self.add(b.fmt("http/{s}", .{name}), directory.path(b, name));
        }
    }
};

/// A module compiled for the build host in Debug: every tool.
fn host_module(b: *std.Build, root_source_file: []const u8) *std.Build.Module {
    return b.createModule(.{
        .root_source_file = b.path(root_source_file),
        .target = b.graph.host,
        .optimize = .Debug,
    });
}
