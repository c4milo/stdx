//! stdx's TLS sessions under QUIC, `quic.Client` and `quic.Server` (decision 87 as amended on
//! 2026-11-26). Each holds chapulin's session. Its `init` takes the program's `Context` and stdx's
//! options, and fills chapulin's `cpu` and `random` from the context, so a program starts a session
//! on no other path. Every other call forwards to chapulin's, as chapulin's docs/zig.md describes it
//! under `quic.quic`. A session holds pointers into itself after `init`, so a program does not move
//! it.
const chapulin = @import("chapulin");
const quic = chapulin.quic;
const session_module = quic.quic;
const init_file = @import("crypto_init.zig");
const options_file = @import("crypto_options.zig");
const Context = init_file.Context;

const Level = session_module.Level;
const Direction = session_module.Direction;
const Version = session_module.Version;

/// A client's options: chapulin's QUIC object's, less the two fields `init` fills.
pub const ClientOptions = options_file.ClientOptions(quic);
/// A server's options: chapulin's QUIC object's, less the two fields `init` fills.
pub const ServerOptions = options_file.ServerOptions(quic);

/// A client whose receive buffer holds `receive_len` bytes, and whose lists hold what `limits`
/// allows.
pub fn Client(comptime receive_len: usize, comptime limits: quic.Limits) type {
    return Session(.client, receive_len, limits);
}

/// A server with the same storage, less the ticket slot.
pub fn Server(comptime receive_len: usize, comptime limits: quic.Limits) type {
    return Session(.server, receive_len, limits);
}

const Side = enum { client, server };

fn Session(comptime side: Side, comptime receive_len: usize, comptime limits: quic.Limits) type {
    const Inner = if (side == .client) session_module.Client(receive_len, limits) else session_module.Server(receive_len, limits);
    return struct {
        const Self = @This();

        /// chapulin's session. A program calls this type's calls, and never the field's.
        session: Inner,

        /// Client: `init(context, &options, transport_params, peer_params)`. Server:
        /// `init(context, &options, transport_params, peer_params, sni_buf)`. `transport_params`
        /// is borrowed for the session, and the peer's are copied into `peer_params`.
        pub const init = if (side == .client) init_client else init_server;
        /// Client: `crypto_in(level, bytes)`. Server: `crypto_in(level, bytes, outgoing)`, which
        /// writes the server's CRYPTO bytes into `outgoing`.
        pub const crypto_in = if (side == .client) crypto_in_client else crypto_in_server;

        fn init_client(self: *Self, context: Context, options: *const ClientOptions, transport_params: []const u8, peer_params: []u8) session_module.InitError!void {
            const values = options_file.chapulin_of(quic, quic.ClientOptions, options, context);
            return self.session.init(&values, transport_params, peer_params);
        }

        fn init_server(self: *Self, context: Context, options: *const ServerOptions, transport_params: []const u8, peer_params: []u8, sni_buf: []u8) session_module.InitError!void {
            const values = options_file.chapulin_of(quic, quic.ServerOptions, options, context);
            return self.session.init(&values, transport_params, peer_params, sni_buf);
        }

        fn crypto_in_client(self: *Self, level: Level, bytes: []const u8) session_module.CryptoInError!void {
            return self.session.crypto_in(level, bytes);
        }

        fn crypto_in_server(self: *Self, level: Level, bytes: []const u8, outgoing: *session_module.Outgoing) session_module.ServerCryptoInError!void {
            return self.session.crypto_in(level, bytes, outgoing);
        }

        pub fn crypto_out(self: *Self, level: Level, out: []u8) session_module.CryptoOutError!usize {
            return self.session.crypto_out(level, out);
        }

        pub fn take_ticket(self: *Self) ?quic.Ticket {
            return self.session.take_ticket();
        }

        pub fn switch_version(self: *Self, version: Version) error{Invalid}!void {
            return self.session.switch_version(version);
        }

        pub fn sni(self: *const Self) ?[]const u8 {
            return self.session.sni();
        }

        pub fn suite(self: *const Self) ?quic.Suite {
            return self.session.suite();
        }

        pub fn server_cert_type(self: *const Self) quic.CertType {
            return self.session.server_cert_type();
        }

        pub fn initial_keys(self: *Self, dcid: []const u8) error{Invalid}!void {
            return self.session.initial_keys(dcid);
        }

        pub fn keys_ready(self: *const Self, level: Level, direction: Direction) bool {
            return self.session.keys_ready(level, direction);
        }

        pub fn peer_transport_params(self: *const Self) error{Cap}!?[]const u8 {
            return self.session.peer_transport_params();
        }

        pub fn seal(self: *Self, level: Level, version: Version, pn: u64, pn_len: usize, hdr: []const u8, pt: []const u8, out: []u8) session_module.SealError!usize {
            return self.session.seal(level, version, pn, pn_len, hdr, pt, out);
        }

        pub fn seal_close(self: *Self, level: Level, version: Version, pn: u64, pn_len: usize, hdr: []const u8, pt: []const u8, out: []u8) session_module.SealError!usize {
            return self.session.seal_close(level, version, pn, pn_len, hdr, pt, out);
        }

        pub fn open(self: *Self, level: Level, version: Version, pkt: []u8, pn_off: usize, largest_pn: u64, current_phase_lowest_pn: u64) session_module.OpenError!session_module.Opened {
            return self.session.open(level, version, pkt, pn_off, largest_pn, current_phase_lowest_pn);
        }

        pub fn retry_ok(self: *const Self, version: Version, pseudo: []const u8, tag: *const [quic.c.CH_QUIC_RETRY_TAG_LEN]u8) bool {
            return self.session.retry_ok(version, pseudo, tag);
        }

        pub fn negotiated_version(self: *const Self) Version {
            return self.session.negotiated_version();
        }

        pub fn key_update(self: *Self) error{Invalid}!void {
            return self.session.key_update();
        }

        pub fn key_phase(self: *const Self) u1 {
            return self.session.key_phase();
        }

        pub fn drop_previous_keys(self: *Self) void {
            self.session.drop_previous_keys();
        }

        pub fn discard(self: *Self, level: Level) error{Invalid}!void {
            return self.session.discard(level);
        }

        pub fn state(self: *const Self) quic.State {
            return self.session.state();
        }

        pub fn alert(self: *const Self) ?quic.AlertDescription {
            return self.session.alert();
        }

        pub fn error_code(self: *const Self) u64 {
            return self.session.error_code();
        }

        pub fn close(self: *Self) void {
            self.session.close();
        }

        pub fn alpn_selected(self: *const Self) ?[]const u8 {
            return self.session.alpn_selected();
        }

        pub fn group(self: *const Self) ?quic.Group {
            return self.session.group();
        }

        pub fn psk_selected(self: *const Self) bool {
            return self.session.psk_selected();
        }
    };
}
