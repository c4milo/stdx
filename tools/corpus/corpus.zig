//! The corpus of decision 15 by the names build/oracle.zig gives its files, so every check over the
//! corpus can refuse to run over a partial one: a file the build drops or adds is a failure, not a
//! quieter run.

const std = @import("std");

/// Every corpus file of decision 15 by the name build/oracle.zig gives it.
pub const names = [_][]const u8{
    "silesia/dickens",            "silesia/mozilla",               "silesia/mr",            "silesia/nci",
    "silesia/ooffice",            "silesia/osdb",                  "silesia/reymont",       "silesia/samba",
    "silesia/sao",                "silesia/webster",               "silesia/x-ray",         "silesia/xml",
    "canterbury/alice29.txt",     "canterbury/asyoulik.txt",       "canterbury/cp.html",    "canterbury/fields.c",
    "canterbury/grammar.lsp",     "canterbury/kennedy.xls",        "canterbury/lcet10.txt", "canterbury/plrabn12.txt",
    "canterbury/ptt5",            "canterbury/sum",                "canterbury/xargs.1",    "canterbury-large/E.coli",
    "canterbury-large/bible.txt", "canterbury-large/world192.txt", "http/html-1k",          "http/html-16k",
    "http/html-1m",               "http/json-1k",                  "http/json-16k",         "http/json-1m",
    "http/js-1k",                 "http/js-16k",                   "http/js-1m",            "http/css-1k",
    "http/css-16k",               "http/css-1m",
};

/// True when `given` holds every name of `names` once and nothing else.
pub fn is_whole(given: []const []const u8) bool {
    if (given.len != names.len) return false;
    for (names) |wanted| {
        var found: usize = 0;
        for (given) |name| {
            if (std.mem.eql(u8, name, wanted)) found += 1;
        }
        if (found != 1) return false;
    }
    return true;
}

// Tests.

const testing = std.testing;

test "the corpus is decision 15's 38 files, and a set with one dropped or added is refused" {
    try testing.expectEqual(38, names.len);
    try testing.expect(is_whole(&names));
    try testing.expect(!is_whole(names[1..]));
    var doubled = names;
    doubled[1] = doubled[0];
    try testing.expect(!is_whole(&doubled));
    const added = names ++ [_][]const u8{"silesia/extra"};
    try testing.expect(!is_whole(&added));
}
