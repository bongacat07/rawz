const arch = @import("../arch/arch.zig");
const errno = @import("../errno.zig");
const types = @import("../types.zig");

pub fn read(fd: types.Fd, buf: []u8) !usize {
    const ret = arch.impl.syscall3(
        arch.num.read,
        @intCast(fd),
        @intFromPtr(buf.ptr),
        buf.len,
    );

    if (ret < 0) {
        return switch (errno.fromRet(ret)) {
            .BADF => error.InvalidFD,
            .FAULT => error.BadBuffer,
            .INTR => error.Interrupted,
            .INVAL => error.InvalidArgument,
            .IO => error.IOError,
            .AGAIN => error.WouldBlock,
            .CONNRESET => error.ConnectionReset,
            else => error.Unexpected,
        };
    }

    return @intCast(ret);
}

pub fn write(fd: types.Fd, buf: []const u8) !usize {
    const ret = arch.impl.syscall3(
        arch.num.write,
        @intCast(fd),
        @intFromPtr(buf.ptr),
        buf.len,
    );

    if (ret < 0) {
        return switch (errno.fromRet(ret)) {
            .BADF => error.InvalidFD,
            .FAULT => error.BadBuffer,
            .INTR => error.Interrupted,
            .INVAL => error.InvalidArgument,
            .IO => error.IOError,
            .AGAIN => error.WouldBlock,
            .PIPE => error.BrokenPipe,
            .CONNRESET => error.ConnectionReset,
            else => error.Unexpected,
        };
    }

    return @intCast(ret);
}

pub fn close(fd: types.Fd) !void {
    const ret = arch.impl.syscall1(arch.num.close, @intCast(fd));

    if (ret < 0) {
        return switch (errno.fromRet(ret)) {
            .BADF => error.InvalidFD,
            .INTR => error.Interrupted,
            .IO => error.IOError,
            else => error.Unexpected,
        };
    }
}

pub fn send(fd: types.Fd, buf: []u8, flags: types.SendFlags) !usize {
    const ret = arch.impl.syscall6(
        arch.num.sendto,
        @intCast(fd),
        @intFromPtr(buf.ptr),
        buf.len,
        @bitCast(flags),
        0,
        0,
    );

    if (ret < 0) {
        return switch (errno.fromRet(ret)) {
            .BADF => error.InvalidFD,
            .FAULT => error.BadBuffer,
            .INTR => error.Interrupted,
            .INVAL => error.InvalidArgument,
            .AGAIN => error.WouldBlock,
            .NOTSOCK => error.NotSocket,
            .DESTADDRREQ => error.DestinationAddressRequired,
            .ISCONN => error.AlreadyConnected,
            .MSGSIZE => error.MessageTooLarge,
            .NOBUFS => error.NoBufferSpace,
            .NOMEM => error.OutOfMemory,
            .NOTCONN => error.NotConnected,
            .OPNOTSUPP => error.OperationNotSupported,
            .PIPE => error.BrokenPipe,
            .CONNRESET => error.ConnectionReset,
            .ACCES => error.AccessDenied,
            .NETDOWN => error.NetworkDown,
            .NETUNREACH => error.NetworkUnreachable,
            .HOSTUNREACH => error.HostUnreachable,
            .EAFNOSUPPORT => error.AddressFamilyNotSupported,
            else => error.Unexpected,
        };
    }

    return @intCast(ret);
}

pub fn sendto(
    fd: types.Fd,
    buf: []u8,
    flags: types.SendFlags,
    addr: *const types.SockAddr,
) !usize {
    const ret = arch.impl.syscall6(
        arch.num.sendto,
        @intCast(fd),
        @intFromPtr(buf.ptr),
        buf.len,
        @bitCast(flags),
        @intFromPtr(addr),
        @sizeOf(types.SockAddr),
    );

    if (ret < 0) {
        return switch (errno.fromRet(ret)) {
            .BADF => error.InvalidFD,
            .FAULT => error.BadBuffer,
            .INTR => error.Interrupted,
            .INVAL => error.InvalidArgument,
            .AGAIN => error.WouldBlock,
            .NOTSOCK => error.NotSocket,
            .DESTADDRREQ => error.DestinationAddressRequired,
            .ISCONN => error.AlreadyConnected,
            .MSGSIZE => error.MessageTooLarge,
            .NOBUFS => error.NoBufferSpace,
            .NOMEM => error.OutOfMemory,
            .NOTCONN => error.NotConnected,
            .OPNOTSUPP => error.OperationNotSupported,
            .PIPE => error.BrokenPipe,
            .CONNRESET => error.ConnectionReset,
            .ACCES => error.AccessDenied,
            .NETDOWN => error.NetworkDown,
            .NETUNREACH => error.NetworkUnreachable,
            .HOSTUNREACH => error.HostUnreachable,
            .AFNOSUPPORT => error.AddressFamilyNotSupported,
            else => error.Unexpected,
        };
    }

    return @intCast(ret);
}

pub fn recv(
    fd: types.Fd,
    buf: []u8,
    flags: types.SendFlags,
) !usize {
    const ret = arch.impl.syscall6(
        arch.num.recvfrom,
        @intCast(fd),
        @intFromPtr(buf.ptr),
        buf.len,
        @bitCast(flags),
        0,
        0,
    );

    if (ret < 0) {
        return switch (errno.fromRet(ret)) {
            .BADF => error.InvalidFD,
            .FAULT => error.BadBuffer,
            .INTR => error.Interrupted,
            .INVAL => error.InvalidArgument,
            .AGAIN => error.WouldBlock,
            .NOTSOCK => error.NotSocket,
            .CONNREFUSED => error.ConnectionRefused,
            .CONNRESET => error.ConnectionReset,
            .NOTCONN => error.NotConnected,
            .TIMEDOUT => error.TimedOut,
            .OPNOTSUPP => error.OperationNotSupported,
            else => error.Unexpected,
        };
    }

    return @intCast(ret);
}

pub fn recvfrom(
    fd: types.Fd,
    buf: []u8,
    flags: types.SendFlags,
    addr: *types.SockAddr,
) !usize {
    var addrlen: u32 = @sizeOf(types.SockAddr);

    const ret = arch.impl.syscall6(
        arch.num.recvfrom,
        @intCast(fd),
        @intFromPtr(buf.ptr),
        buf.len,
        @bitCast(flags),
        @intFromPtr(addr),
        @intFromPtr(&addrlen),
    );

    if (ret < 0) {
        return switch (errno.fromRet(ret)) {
            .BADF => error.InvalidFD,
            .FAULT => error.BadBuffer,
            .INTR => error.Interrupted,
            .INVAL => error.InvalidArgument,
            .AGAIN => error.WouldBlock,
            .NOTSOCK => error.NotSocket,
            .CONNREFUSED => error.ConnectionRefused,
            .CONNRESET => error.ConnectionReset,
            .NOTCONN => error.NotConnected,
            .TIMEDOUT => error.TimedOut,
            .OPNOTSUPP => error.OperationNotSupported,
            else => error.Unexpected,
        };
    }

    return @intCast(ret);
}
