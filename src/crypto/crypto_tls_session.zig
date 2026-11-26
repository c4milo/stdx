//! stdx's TLS sessions over TCP, `tls.Client` and `tls.Server` (decision 87 as amended on
//! 2026-11-26). Each holds chapulin's session. Its `init` takes the program's `Context` and stdx's
//! options, and fills chapulin's `cpu` and `random` from the context, so a program starts a session
//! on no other path. Every other call forwards to chapulin's, as chapulin's docs/zig.md describes it
//! under `tcp.tcp`. A session holds pointers into itself after `init`, so a program does not move
//! it.
const chapulin = @import("chapulin");
const tcp = chapulin.tcp;
const session_module = tcp.tcp;
const init_file = @import("crypto_init.zig");
const options_file = @import("crypto_options.zig");
const Context = init_file.Context;

/// A client's options: chapulin's, less the two fields `init` fills.
pub const ClientOptions = options_file.ClientOptions(tcp);
/// A server's options: chapulin's, less the two fields `init` fills.
pub const ServerOptions = options_file.ServerOptions(tcp);

/// A client whose receive buffer holds `receive_len` bytes, and whose lists hold what `limits`
/// allows.
pub fn Client(comptime receive_len: usize, comptime limits: tcp.Limits) type {
    return Session(.client, receive_len, limits);
}

/// A server with the same storage, less the ticket slot.
pub fn Server(comptime receive_len: usize, comptime limits: tcp.Limits) type {
    return Session(.server, receive_len, limits);
}

const Side = enum { client, server };

fn Session(comptime side: Side, comptime receive_len: usize, comptime limits: tcp.Limits) type {
    const Inner = if (side == .client) session_module.Client(receive_len, limits) else session_module.Server(receive_len, limits);
    return struct {
        const Self = @This();

        /// chapulin's session. A program calls this type's calls, and never the field's.
        session: Inner,

        /// Client: `init(context, &options)`. Server: `init(context, &options, sni_buf)`, where
        /// `sni_buf` receives the server_name the client sends.
        pub const init = if (side == .client) init_client else init_server;
        /// Client: `record_in(input)`. Server: `record_in(input, output)`, which writes the
        /// server's flight into `output`.
        pub const record_in = if (side == .client) record_in_client else record_in_server;
        /// chapulin has no call that starts a KeyUpdate over TCP, and names that in a compile error.
        pub const key_update = Inner.key_update;

        fn init_client(self: *Self, context: Context, options: *const ClientOptions) session_module.InitError!void {
            const values = options_file.chapulin_of(tcp, tcp.ClientOptions, options, context);
            return self.session.init(&values);
        }

        fn init_server(self: *Self, context: Context, options: *const ServerOptions, sni_buf: []u8) session_module.InitError!void {
            const values = options_file.chapulin_of(tcp, tcp.ServerOptions, options, context);
            return self.session.init(&values, sni_buf);
        }

        fn record_in_client(self: *Self, input: []u8) session_module.RecordInError!usize {
            return self.session.record_in(input);
        }

        fn record_in_server(self: *Self, input: []u8, output: []u8) session_module.ServerRecordInError!session_module.Progress {
            return self.session.record_in(input, output);
        }

        pub fn record_out(self: *Self, output: []u8) session_module.RecordOutError!usize {
            return self.session.record_out(output);
        }

        pub fn output_len(self: *const Self) usize {
            return self.session.output_len();
        }

        pub fn take_ticket(self: *Self) ?tcp.Ticket {
            return self.session.take_ticket();
        }

        pub fn sni(self: *const Self) ?[]const u8 {
            return self.session.sni();
        }

        pub fn export_keying_material(self: *const Self, label: [:0]const u8, context: []const u8, out: []u8) session_module.ExportError!void {
            return self.session.export_keying_material(label, context, out);
        }

        pub fn alpn_selected(self: *const Self) ?[]const u8 {
            return self.session.alpn_selected();
        }

        pub fn suite(self: *const Self) ?tcp.Suite {
            return self.session.suite();
        }

        pub fn server_cert_type(self: *const Self) tcp.CertType {
            return self.session.server_cert_type();
        }

        pub fn state(self: *const Self) tcp.State {
            return self.session.state();
        }

        pub fn alert_sent(self: *const Self) ?tcp.AlertDescription {
            return self.session.alert_sent();
        }

        pub fn alert_received(self: *const Self) ?tcp.AlertDescription {
            return self.session.alert_received();
        }

        pub fn read(self: *Self, input: []const u8, pt: []u8, reply: []u8) session_module.ReadError!session_module.Read {
            return self.session.read(input, pt, reply);
        }

        pub fn write(self: *Self, pt: []const u8, output: []u8) session_module.WriteError!usize {
            return self.session.write(pt, output);
        }

        pub fn write_parts(self: *Self, parts: []const []const u8, output: []u8) session_module.WriteError!usize {
            return self.session.write_parts(parts, output);
        }

        pub fn writable_len(self: *const Self, cap: usize) usize {
            return self.session.writable_len(cap);
        }

        pub fn end(self: *Self, output: []u8) session_module.EndError!usize {
            return self.session.end(output);
        }

        pub fn fail(self: *Self, description: tcp.AlertDescription, output: []u8) session_module.FailError!usize {
            return self.session.fail(description, output);
        }

        pub fn close(self: *Self) void {
            self.session.close();
        }

        pub fn group(self: *const Self) ?tcp.Group {
            return self.session.group();
        }

        pub fn psk_selected(self: *const Self) bool {
            return self.session.psk_selected();
        }

        pub fn peer_limit(self: *const Self) u16 {
            return self.session.peer_limit();
        }

        pub fn read_closed(self: *const Self) bool {
            return self.session.read_closed();
        }

        pub fn reply_len(self: *const Self) usize {
            return self.session.reply_len();
        }
    };
}
