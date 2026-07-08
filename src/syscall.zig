const types = @import("types.zig");
const linux_syscall = @import("x86_64_syscalln.zig");
const errno = @import("errno.zig");

pub const SYS = struct {
    pub const read = 0;
    pub const write = 1;
    pub const close = 3;
    pub const socket = 41;
    pub const accept = 43;
    pub const bind = 49;
    pub const listen = 50;
};

pub fn socket(
    domain: types.AddressFamily,
    type_: types.SocketType,
    protocol: ?types.Protocol,
) !types.Fd {
    const ret = linux_syscall.syscall3(
        SYS.socket,
        @as(usize, @intCast(@intFromEnum(domain))),
        @as(usize, @intCast(@intFromEnum(type_))),
        @as(usize, @intCast(if (protocol) |p| @intFromEnum(p) else 0)),
    );

    if (ret < 0) {
        return switch (errno.fromRet(ret)) {
            .PERM, .ACCES => error.AccessDenied,
            .AFNOSUPPORT => error.AddressFamilyNotSupported,
            .PROTONOSUPPORT => error.ProtocolNotSupported,
            .NFILE, .MFILE => error.SystemResources,
            else => error.Unexpected,
        };
    }

    return .{ .fd = @intCast(ret) };
}

pub fn close(fd: types.Fd) !void {
    const ret = linux_syscall.syscall1(SYS.close, @as(usize, @intCast(fd.fd)));

    if (ret < 0) {
        return switch (errno.fromRet(ret)) {
            .BADF => error.InvalidFD,
            .INTR => error.Interrupted,
            .IO => error.IOError,
            else => error.Unexpected,
        };
    }
}
