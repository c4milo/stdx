//! The corpora of decision 15, gathered for build/oracle.zig: the files of the three fetched
//! corpora, the HTTP payloads tools/corpus/cut.zig cuts to their three sizes, and the literal-heavy
//! text tools/corpus/shuffle.zig derives from Silesia's dickens (decision 25). Every check and
//! benchmark over the corpora takes these files, and `zig build corpus -Doracles` installs them.
const std = @import("std");

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

/// One corpus file the checks read.
pub const File = struct {
    name: []const u8,
    path: std.Build.LazyPath,
};

pub const Corpus = struct {
    /// Every file, the cut HTTP pieces and the shuffled text included.
    files: []const File,
    /// The directory holding the derived files and a copy of every other file.
    pieces: std.Build.LazyPath,
};

/// The modules of the tools that derive corpus files.
pub const Tools = struct {
    /// tools/corpus/cut.zig.
    cut: *std.Build.Module,
    /// tools/corpus/shuffle.zig.
    shuffle: *std.Build.Module,
};

/// Every corpus file of decision 15, with the HTTP payloads cut to their three sizes and dickens's
/// first MiB shuffled. Null until the packages are fetched.
pub fn add(b: *std.Build, tools: Tools) ?Corpus {
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

    const cut = b.addExecutable(.{ .name = "corpus_cut", .root_module = tools.cut });
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

    const shuffle = b.addExecutable(.{ .name = "corpus_shuffle", .root_module = tools.shuffle });
    gathering.add_shuffled(shuffle, "dickens", silesia.path("dickens"));
    return .{ .files = gathering.files.items, .pieces = gathering.copies.getDirectory() };
}

/// Passes every corpus file to `run` as `<name>=<path>`.
pub fn add_args(b: *std.Build, run: *std.Build.Step.Run, corpus: Corpus) void {
    for (corpus.files) |file| run.addPrefixedFileArg(b.fmt("{s}=", .{file.name}), file.path);
}

/// The corpus files as they are added: the list the checks read, and a directory holding a copy of
/// each.
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

    /// The first MiB of `source` in the order tools/corpus/shuffle.zig draws, labelled
    /// `shuffled/<name>-1m`.
    fn add_shuffled(self: *Gathering, shuffle: *std.Build.Step.Compile, name: []const u8, source: std.Build.LazyPath) void {
        const b = self.b;
        const run = b.addRunArtifact(shuffle);
        const label = b.fmt("{s}-1m", .{name});
        const output = run.addOutputFileArg(label);
        run.addFileArg(source);
        self.add(b.fmt("shuffled/{s}", .{label}), output);
    }
};
