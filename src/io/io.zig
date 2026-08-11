const types = @import("../types/types.zig");
const arch = @import("../arch/arch.zig");
const errno = @import("../errno.zig");

pub fn read(fd: types.Fd, buf: []u8) !usize {
    const ret = arch.impl.syscall3(
        arch.num.SYS.read,
        @as(usize, @intCast(fd.fd)),
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
        arch.num.SYS.write,
        @as(usize, @intCast(fd.fd)),
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
    const ret = arch.impl.syscall1(arch.num.SYS.close, @as(usize, @intCast(fd.fd)));

    if (ret < 0) {
        return switch (errno.fromRet(ret)) {
            .BADF => error.InvalidFD,
            .INTR => error.Interrupted,
            .IO => error.IOError,
            else => error.Unexpected,
        };
    }
}
