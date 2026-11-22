//! Tests of claims R2 to R5 with the host's CPU features (decision 86): a searcher whose literals
//! search `avx2_lanes` octets a step, where the host has AVX2, gives what the matcher gives.
const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const searcher_test = @import("searcher_test.zig");
const Fixture = searcher_test.Fixture;
const literal_test = @import("searcher_literal_test.zig");
const suffix_test = @import("searcher_suffix_test.zig");
const has_kernels = @import("../literal.zig").has_kernels;

/// The texts a test draws for each pattern, and the seed it draws them from.
const texts_per_pattern = 4;
const seed = 0x3A1D;

/// Requires the searcher, with `features`, to give what the matcher gives for each pattern over
/// texts drawn from `alphabet`, and its literals to search as wide as the features allow.
fn expect_agree_wide(fixture: *Fixture, features: codec.Features, patterns: []const []const u8, alphabet: []const u8) !void {
    var generator = codec.testing.split.Generator.init(seed);
    var haystack: [literal_test.haystack_len]u8 = undefined;
    const wide = has_kernels and features.avx2;
    const ssse3 = has_kernels and features.ssse3 and !features.avx2;
    for (patterns) |pattern| {
        try fixture.init(pattern, 0);
        try fixture.init(pattern, searcher_test.cache_sizes(&fixture.program).most);
        if (fixture.searcher.forward.literal) |literal| try testing.expectEqual(wide, literal.wide);
        if (fixture.searcher.forward.literals) |set| {
            try testing.expectEqual(wide, set.wide);
            try testing.expectEqual(ssse3, set.ssse3);
        }
        if (fixture.searcher.suffix) |suffix| try testing.expectEqual(wide, suffix.wide);
        for (0..texts_per_pattern) |_| {
            for (&haystack) |*octet| octet.* = alphabet[generator.below(alphabet.len)];
            try fixture.expect_agree_everywhere(&haystack);
        }
    }
}

test "a searcher with the host's features gives what the matcher gives, for each claim's patterns" {
    var fixture: Fixture = .{ .features = codec.Features.detect() };
    try expect_agree_wide(&fixture, fixture.features, &literal_test.patterns, literal_test.alphabet);
    try expect_agree_wide(&fixture, fixture.features, &literal_test.looks_patterns, literal_test.looks_alphabet);
    try expect_agree_wide(&fixture, fixture.features, &literal_test.folds_patterns, literal_test.folds_alphabet);
    try expect_agree_wide(&fixture, fixture.features, &literal_test.sets_patterns, literal_test.sets_alphabet);
    var suffixes: [suffix_test.suffix_cases.len][]const u8 = undefined;
    for (&suffixes, suffix_test.suffix_cases) |*pattern, case| pattern.* = case.pattern;
    try expect_agree_wide(&fixture, fixture.features, &suffixes, suffix_test.alphabet);
}

/// Sets of `teddy_count_min` literals and more, which SSSE3's Teddy searches.
const teddy_sets = [_][]const u8{ "Abraham|Isaac|Jacob|Joseph", "Ab|Is|Ja|Jo|Mo|Aa|Da|Sa", "(?:Ab|Is|Ja|Jo)[a-z]" };

test "a searcher with SSSE3 and no AVX2, as an older CPU has, gives what the matcher gives for sets" {
    if (!(has_kernels and codec.Features.detect().ssse3)) return error.SkipZigTest;
    var fixture: Fixture = .{ .features = .{ .ssse3 = true } };
    try expect_agree_wide(&fixture, fixture.features, &literal_test.sets_patterns, literal_test.sets_alphabet);
    try expect_agree_wide(&fixture, fixture.features, &teddy_sets, literal_test.sets_alphabet);
}
