//! stdx's options of chapulin's sessions (decision 87 as amended on 2026-11-26). Each holds every
//! field of chapulin's options, with chapulin's type and default, but `cpu` and `random`. stdx
//! fills those two from the program's `Context` when a session starts, so no program names
//! chapulin's description of the CPU, and none can set it. chapulin's docs/zig.md describes each
//! field, under the object `tcp` or `quic`. The module's root exports the types through `tls` and
//! `quic`, and does not export this file.
const std = @import("std");
const chapulin = @import("chapulin");
const init_file = @import("crypto_init.zig");
const Context = init_file.Context;

/// The fields of chapulin's options that stdx fills, and that stdx's options leave out.
pub const filled_fields = [_][]const u8{ "cpu", "random" };

/// A client's options over `Object`, chapulin's `tcp` or `quic` object.
pub fn ClientOptions(comptime Object: type) type {
    const Chapulin = Object.ClientOptions;
    return struct {
        /// How the server is judged.
        trust: @FieldType(Chapulin, "trust"),
        /// Protocol names to offer, most preferred first.
        alpn: @FieldType(Chapulin, "alpn") = default_of(Chapulin, "alpn"),
        /// A ticket to resume with.
        ticket: @FieldType(Chapulin, "ticket") = default_of(Chapulin, "ticket"),
        /// The ticket's age in milliseconds.
        ticket_age_ms: @FieldType(Chapulin, "ticket_age_ms") = default_of(Chapulin, "ticket_age_ms"),
        /// Whether the session keeps the tickets the server sends, for `take_ticket`.
        takes_tickets: @FieldType(Chapulin, "takes_tickets") = default_of(Chapulin, "takes_tickets"),
        /// Refuse a key exchange other than X25519MLKEM768.
        require_pq: @FieldType(Chapulin, "require_pq") = default_of(Chapulin, "require_pq"),
        /// The QUIC version of the first Initial packet, in the QUIC object alone.
        quic_version: @FieldType(Chapulin, "quic_version") = default_of(Chapulin, "quic_version"),
        /// Suites to offer, most preferred first, empty for the build's order.
        cipher_suites: @FieldType(Chapulin, "cipher_suites") = default_of(Chapulin, "cipher_suites"),
        /// The caller's context, which the session's hook stores.
        context: @FieldType(Chapulin, "context") = default_of(Chapulin, "context"),
    };
}

/// A server's options over `Object`, chapulin's `tcp` or `quic` object.
pub fn ServerOptions(comptime Object: type) type {
    const Chapulin = Object.ServerOptions;
    return struct {
        const Self = @This();

        /// An ecdsa_secp256r1_sha256 identity, null for none.
        ecdsa_p256: @FieldType(Chapulin, "ecdsa_p256") = default_of(Chapulin, "ecdsa_p256"),
        /// An rsa_pss_rsae_sha256 identity, null for none.
        rsa_pss: @FieldType(Chapulin, "rsa_pss") = default_of(Chapulin, "rsa_pss"),
        /// An mldsa87 identity, null for none.
        mldsa87: @FieldType(Chapulin, "mldsa87") = default_of(Chapulin, "mldsa87"),
        /// The HelloRetryRequest cookie key.
        cookie_key: @FieldType(Chapulin, "cookie_key"),
        /// The key tickets are sealed under, null for no tickets.
        ticket_key: @FieldType(Chapulin, "ticket_key") = default_of(Chapulin, "ticket_key"),
        /// The key `ticket_key` replaced, which opens tickets and seals none.
        ticket_key_previous: @FieldType(Chapulin, "ticket_key_previous") = default_of(Chapulin, "ticket_key_previous"),
        /// The caller's clock, null for no tickets.
        clock: @FieldType(Chapulin, "clock") = default_of(Chapulin, "clock"),
        /// Protocol names to select from, in this server's order.
        alpn: @FieldType(Chapulin, "alpn") = default_of(Chapulin, "alpn"),
        /// Refuse a ClientHello with no server_name.
        require_server_name: @FieldType(Chapulin, "require_server_name") = default_of(Chapulin, "require_server_name"),
        /// Suites in this server's order, empty for the default.
        cipher_suites: @FieldType(Chapulin, "cipher_suites") = default_of(Chapulin, "cipher_suites"),
        /// The Version field of the client's first Initial packet, in the QUIC object alone.
        quic_version: @FieldType(Chapulin, "quic_version") = default_of(Chapulin, "quic_version"),
        /// The negotiated version's chooser, in the QUIC object alone.
        choose_version: @FieldType(Chapulin, "choose_version") = default_of(Chapulin, "choose_version"),
        /// The caller's context, which the session's hook stores.
        context: @FieldType(Chapulin, "context") = default_of(Chapulin, "context"),

        /// chapulin's `check`: each provisioned key signs, and the signature verifies, on the
        /// instructions the context's features hold. The RSA-PSS salt is drawn from the context's
        /// random source.
        pub fn check(self: *const Self, context: Context) error{Invalid}!void {
            const values = chapulin_of(Object, Chapulin, self, context);
            return values.check();
        }
    };
}

/// The default of `Options`' field `name`, which stdx's options take as their own.
fn default_of(comptime Options: type, comptime name: []const u8) @FieldType(Options, name) {
    inline for (@typeInfo(Options).@"struct".fields) |field| {
        if (comptime std.mem.eql(u8, field.name, name)) return comptime field.defaultValue().?;
    }
    @compileError("chapulin's options have no field " ++ name);
}

/// chapulin's options of `Object`: each field of `options`, and `cpu` and `random` from `context`.
pub fn chapulin_of(comptime Object: type, comptime Chapulin: type, options: anytype, context: Context) Chapulin {
    const Ours = @TypeOf(options.*);
    comptime std.debug.assert(std.meta.fields(Ours).len + filled_fields.len == std.meta.fields(Chapulin).len);
    var values: Chapulin = undefined;
    inline for (std.meta.fields(Ours)) |field| {
        @field(values, field.name) = @field(options.*, field.name);
    }
    // A device object holds neither field: chapulin makes each `void` there.
    values.cpu = if (@FieldType(Chapulin, "cpu") == void) {} else cpu_of(Object, context);
    values.random = if (@FieldType(Chapulin, "random") == void) {} else context.random;
    return values;
}

/// chapulin's description of the CPU for `Object`'s calls, on the calling thread.
fn cpu_of(comptime Object: type, context: Context) Object.Cpu {
    return if (Object == chapulin.quic) init_file.quic_cpu(context) else init_file.tcp_cpu(context);
}

// Tests.

const testing = std.testing;
const platform = @import("platform");

fn is_filled(name: []const u8) bool {
    for (filled_fields) |filled| {
        if (std.mem.eql(u8, filled, name)) return true;
    }
    return false;
}

/// Each field of `Chapulin` but the filled two is a field of `Ours`, in chapulin's order, with
/// chapulin's type and default, and `Ours` has no other field.
fn expect_mirrors(comptime Ours: type, comptime Chapulin: type) !void {
    comptime var index = 0;
    inline for (std.meta.fields(Chapulin)) |field| {
        if (comptime is_filled(field.name)) continue;
        const ours = std.meta.fields(Ours)[index];
        try testing.expectEqualStrings(field.name, ours.name);
        try testing.expect(ours.type == field.type);
        try testing.expect(std.meta.eql(field.defaultValue(), ours.defaultValue()));
        index += 1;
    }
    try testing.expectEqual(std.meta.fields(Ours).len, index);
}

test "stdx's options hold every field of chapulin's but cpu and random, as chapulin types them" {
    try expect_mirrors(ClientOptions(chapulin.tcp), chapulin.tcp.ClientOptions);
    try expect_mirrors(ServerOptions(chapulin.tcp), chapulin.tcp.ServerOptions);
    try expect_mirrors(ClientOptions(chapulin.quic), chapulin.quic.ClientOptions);
    try expect_mirrors(ServerOptions(chapulin.quic), chapulin.quic.ServerOptions);
    try testing.expect(!@hasField(ClientOptions(chapulin.tcp), "cpu") and !@hasField(ServerOptions(chapulin.quic), "random"));
}

/// A fixed source for the tests, which writes zeros. It is no random source.
fn zeros(_: *anyopaque, bytes: []u8) void {
    @memset(bytes, 0);
}

test "chapulin's options carry stdx's fields, the context's description and its random source" {
    var source_state: u8 = 0;
    const context = init_file.init(platform.CpuFeatures.detect(), .{ .ptr = &source_state, .fillFn = zeros });
    const alpn = [_][]const u8{"h2"};
    const options: ClientOptions(chapulin.tcp) = .{ .trust = undefined, .alpn = &alpn, .ticket_age_ms = 7, .require_pq = true };
    const values = chapulin_of(chapulin.tcp, chapulin.tcp.ClientOptions, &options, context);
    try testing.expectEqual(init_file.tcp_cpu(context), values.cpu.?);
    try testing.expectEqual(context.random.ptr, values.random.?.ptr);
    try testing.expectEqual(@as(u64, 7), values.ticket_age_ms);
    try testing.expect(values.require_pq and values.alpn.ptr == &alpn);
    const cookie_key = [_]u8{0} ** chapulin.quic.c.CH_SRV_COOKIE_KEY_LEN;
    const server: ServerOptions(chapulin.quic) = .{ .cookie_key = &cookie_key };
    const quic_values = chapulin_of(chapulin.quic, chapulin.quic.ServerOptions, &server, context);
    try testing.expectEqual(init_file.quic_cpu(context), quic_values.cpu.?);
    try testing.expect(quic_values.cookie_key == &cookie_key);
}
