//! Handshakes through stdx's sessions, over TCP and under QUIC, which hold that each session's
//! `init` fills chapulin's options from the `Context` and that its calls reach chapulin's.
//!
//! The server's identity in testdata/ is a self-signed P-256 certificate for localhost, which the
//! client trusts by the SHA-256 of its SubjectPublicKeyInfo alone, so no clock or anchor takes
//! part. These openssl 3 commands made it:
//!
//!     openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -nodes \
//!       -keyout leaf.key.pem -out leaf.pem -days 36500 -subj "/CN=localhost" \
//!       -addext "subjectAltName=DNS:localhost"
//!     openssl pkcs8 -topk8 -nocrypt -in leaf.key.pem -out leaf.key.pem
//!     openssl x509 -in leaf.pem -pubkey -noout | openssl pkey -pubin -outform DER \
//!       | openssl dgst -sha256 -hex | awk '{print $2}' > leaf.spki.sha256
const std = @import("std");
const platform = @import("platform");
const crypto = @import("crypto.zig");
const tls = crypto.tls;
const quic = crypto.quic;
const testing = std.testing;

const leaf_pem = @embedFile("testdata/leaf.pem");
const key_pem = @embedFile("testdata/leaf.key.pem");
const pin_hex = @embedFile("testdata/leaf.spki.sha256");

const receive_len = 20_480;
const alpn = [_][]const u8{"h2"};
const server_name = "localhost";
/// The room for the leaf certificate's DER, which is under 1 KiB.
const der_len_max = 2048;
/// The room of each direction's pipe, which holds a whole flight.
const pipe_len = 32_768;
/// The room for one record's plaintext and for a read's reply.
const transfer_len_max = 256;
/// The room for one test packet, its header and its tag.
const packet_len_max = 64;
/// A 1-RTT packet's first byte with the fixed bit and a 2-byte packet number (RFC 9000 §17.3.1).
const short_header_byte = 0x41;
const packet_number_len = 2;
/// The length of the secret each side exports.
const secret_len = 32;
/// The byte the HelloRetryRequest cookie key repeats.
const cookie_byte = 0x5a;

/// A fixed source for the tests, which writes the bytes of a counter. It is no random source: a
/// program passes the operating system's entropy, as src/crypto/README.md shows.
const Counter = struct {
    count: u8 = 1,

    fn fill(pointer: *anyopaque, bytes: []u8) void {
        const counter: *Counter = @ptrCast(@alignCast(pointer));
        for (bytes) |*byte| {
            byte.* = counter.count;
            counter.count +%= 1;
        }
    }
};

/// The server's identity, decoded from testdata/ into its own storage.
const Identity = struct {
    der: [der_len_max]u8 = undefined,
    slices: [1][]const u8 = undefined,
    chain: tls.Chain = .{},
    key: tls.EcdsaP256Key = .{},
    pins: [1]tls.SpkiPin = undefined,

    fn load(self: *Identity, context: crypto.Context) !void {
        self.chain = try tls.Chain.from_pem(leaf_pem, &self.der, &self.slices);
        try tls.init_from_pem(context, &self.key, key_pem, self.chain.leaf());
        _ = try std.fmt.hexToBytes(&self.pins[0], std.mem.trimEnd(u8, pin_hex, "\n"));
    }
};

/// Bytes one side wrote and the other has not yet taken.
const Pipe = struct {
    bytes: [pipe_len]u8 = undefined,
    start: usize = 0,
    end: usize = 0,

    fn pending(self: *Pipe) []u8 {
        return self.bytes[self.start..self.end];
    }

    fn free(self: *Pipe) []u8 {
        return self.bytes[self.end..];
    }

    fn push(self: *Pipe, n: usize) void {
        self.end += n;
    }

    fn pop(self: *Pipe, n: usize) void {
        self.start += n;
    }
};

const cookie_key = [_]u8{cookie_byte} ** tls.c.CH_SRV_COOKIE_KEY_LEN;

test "a TCP client and server run a handshake through stdx's sessions and move data both ways" {
    var counter: Counter = .{};
    const context = crypto.init(platform.CpuFeatures.detect(), .{ .ptr = &counter, .fillFn = Counter.fill });
    var identity: Identity = .{};
    try identity.load(context);
    defer identity.key.wipe();
    const server_options: tls.ServerOptions = .{
        .ecdsa_p256 = .{ .chain = identity.chain.certs, .public_key = &identity.key.public_key, .private_key = &identity.key.private_key },
        .cookie_key = &cookie_key,
        .alpn = &alpn,
    };
    try server_options.check(context);
    const client_options: tls.ClientOptions = .{ .trust = .{ .pins = .{ .pins = &identity.pins, .server_name = server_name } }, .alpn = &alpn };

    var server: tls.Server(receive_len, .{}) = undefined;
    var client: tls.Client(receive_len, .{}) = undefined;
    var sni_buf: [255]u8 = undefined;
    try server.init(context, &server_options, &sni_buf);
    try client.init(context, &client_options);
    var to_server: Pipe = .{};
    var to_client: Pipe = .{};
    for (0..4) |_| {
        to_server.push(try client.record_out(to_server.free()));
        if (to_server.pending().len > 0) {
            const progress = try server.record_in(to_server.pending(), to_client.free());
            to_server.pop(progress.consumed);
            to_client.push(progress.written);
        }
        if (client.state() == .connected) break;
        if (to_client.pending().len > 0) to_client.pop(try client.record_in(to_client.pending()));
    }
    try testing.expectEqual(tls.State.connected, client.state());
    try testing.expectEqual(tls.State.connected, server.state());
    try testing.expectEqualStrings("h2", client.alpn_selected().?);
    try testing.expectEqualStrings(server_name, server.sni().?);
    try testing.expect(client.suite() != null and client.group() != null and !client.psk_selected());
    try expect_transfer(&client, &server, &to_server, "a request");
    try expect_transfer(&server, &client, &to_client, "a response");
    try expect_connected_calls(&client, &server, &to_server);
}

/// The calls of two connected TCP sessions: a write in parts, the limits, an exported secret, and
/// the end, which the server reads as the peer's close.
fn expect_connected_calls(client: anytype, server: anytype, to_server: *Pipe) !void {
    to_server.push(try client.write_parts(&.{ "two ", "parts" }, to_server.free()));
    var plaintext: [transfer_len_max]u8 = undefined;
    var reply: [transfer_len_max]u8 = undefined;
    var read = try server.read(to_server.pending(), &plaintext, &reply);
    to_server.pop(read.consumed);
    try testing.expectEqualStrings("two parts", plaintext[0..read.pt_len]);
    try testing.expect(client.writable_len(transfer_len_max) > 0 and client.peer_limit() > 0);
    var client_secret: [secret_len]u8 = undefined;
    var server_secret: [secret_len]u8 = undefined;
    try client.export_keying_material("EXPORTER-stdx", "", &client_secret);
    try server.export_keying_material("EXPORTER-stdx", "", &server_secret);
    try testing.expectEqualSlices(u8, &client_secret, &server_secret);
    // Another label gives another secret, so the two ends agree on chapulin's secret, not on a
    // fixed value.
    try client.export_keying_material("EXPORTER-stdx-other", "", &server_secret);
    try testing.expect(!std.mem.eql(u8, &client_secret, &server_secret));
    try testing.expect(client.alert_sent() == null and server.alert_received() == null);
    to_server.push(try client.end(to_server.free()));
    read = try server.read(to_server.pending(), &plaintext, &reply);
    try testing.expect(read.peer_closed and server.read_closed() and server.reply_len() == read.reply_len);
    // close_notify is no fatal alert, which alert_received alone reports.
    try testing.expect(server.alert_received() == null);
}

/// `data` from `writer` to `reader` through `wire`, which arrives whole.
fn expect_transfer(writer: anytype, reader: anytype, wire: *Pipe, data: []const u8) !void {
    wire.push(try writer.write(data, wire.free()));
    var plaintext: [transfer_len_max]u8 = undefined;
    var reply: [transfer_len_max]u8 = undefined;
    const read = try reader.read(wire.pending(), &plaintext, &reply);
    wire.pop(read.consumed);
    try testing.expectEqualStrings(data, plaintext[0..read.pt_len]);
}

test "a QUIC client and server run a handshake through stdx's sessions and seal a packet each way" {
    var counter: Counter = .{};
    const context = crypto.init(platform.CpuFeatures.detect(), .{ .ptr = &counter, .fillFn = Counter.fill });
    var identity: Identity = .{};
    try identity.load(context);
    defer identity.key.wipe();
    const server_options: quic.ServerOptions = .{
        .ecdsa_p256 = .{ .chain = identity.chain.certs, .public_key = &identity.key.public_key, .private_key = &identity.key.private_key },
        .cookie_key = &cookie_key,
        .alpn = &alpn,
        .quic_version = .v1,
    };
    const client_options: quic.ClientOptions = .{ .trust = .{ .pins = .{ .pins = &identity.pins, .server_name = server_name } }, .alpn = &alpn, .quic_version = .v1 };

    var server: quic.Server(receive_len, .{}) = undefined;
    var client: quic.Client(receive_len, .{}) = undefined;
    var sni_buf: [255]u8 = undefined;
    var client_peer: [64]u8 = undefined;
    var server_peer: [64]u8 = undefined;
    const client_params = [_]u8{ 0x01, 0x02, 0x03 };
    const server_params = [_]u8{ 0x04, 0x05 };
    try server.init(context, &server_options, &server_params, &server_peer, &sni_buf);
    try client.init(context, &client_options, &client_params, &client_peer);
    const dcid = [_]u8{ 0x83, 0x94, 0xc8, 0xf0, 0x3e, 0x51, 0x57, 0x08 };
    try client.initial_keys(&dcid);
    try server.initial_keys(&dcid);

    var buffers: [quic.level_count][4096]u8 = undefined;
    var outgoing: quic.Outgoing = .{ .buffers = .{ &buffers[0], &buffers[1], &buffers[2] } };
    var message: [4096]u8 = undefined;
    var n = try client.crypto_out(.initial, &message);
    try server.crypto_in(.initial, message[0..n], &outgoing);
    try client.crypto_in(.initial, buffers[0][0..outgoing.written[0]]);
    try client.crypto_in(.handshake, buffers[1][0..outgoing.written[1]]);
    n = try client.crypto_out(.handshake, &message);
    try server.crypto_in(.handshake, message[0..n], &outgoing);
    try testing.expectEqual(quic.State.connected, client.state());
    try testing.expectEqual(quic.State.connected, server.state());
    try testing.expectEqualStrings("h2", client.alpn_selected().?);
    try testing.expectEqualSlices(u8, &server_params, (try client.peer_transport_params()).?);
    try testing.expectEqualSlices(u8, &client_params, (try server.peer_transport_params()).?);
    try expect_packet(&server, &client, 5);
    try expect_packet(&client, &server, 6);
    try testing.expect(client.alert() == null and client.error_code() == 0 and !client.psk_selected());
    try testing.expectEqual(@as(u1, 0), client.key_phase());
    try client.key_update();
    try testing.expectEqual(@as(u1, 1), client.key_phase());
    try client.discard(.initial);
    try testing.expect(!client.keys_ready(.initial, .write) and client.keys_ready(.application, .write));
}

/// One 1-RTT packet, numbered `pn`, from `sealer` to `opener`.
fn expect_packet(sealer: anytype, opener: anytype, pn: u8) !void {
    const pt = "one packet";
    const version = sealer.negotiated_version();
    var packet: [packet_len_max]u8 = undefined;
    const header = [_]u8{ short_header_byte, 0x00, pn };
    const n = try sealer.seal(.application, version, pn, packet_number_len, &header, pt, &packet);
    const opened = try opener.open(.application, version, packet[0..n], 1, 0, 0);
    try testing.expectEqual(@as(u64, pn), opened.pn);
    try testing.expectEqualStrings(pt, packet[header.len..][0..opened.pt_len]);
}
