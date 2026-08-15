const std = @import("std");

pub const Fd = i32;

pub const SocketType = enum(c_int) {
    stream = 1,
    dgram = 2,
    raw = 3,
};

pub const AddressFamily = enum(c_int) {
    unix = 1,
    inet = 2,
    inet6 = 10,
};

pub const Protocol = enum(c_int) {
    tcp = 6,
    udp = 17,
};

pub const SockAddrIn = extern struct {
    family: u16 = @intFromEnum(AddressFamily.inet),
    port: u16,
    addr: u32,
    zero: [8]u8 = @splat(0),
};

pub const SockAddr = extern struct {
    family: u16,
    sa_data: [14]u8,
};

pub fn htons(port: u16) u16 {
    return @byteSwap(port);
}

pub fn htonl(addr: u32) u32 {
    return @byteSwap(addr);
}

pub const Acccept4Flags = packed struct(u32) {
    _pad1: u11 = 0,
    nonblock: bool,
    _pad2: u7 = 0,
    cloexec: bool,
    _pad3: u12 = 0,
};

pub const ShutdownHow = enum(u32) {
    read = 0,
    write = 1,
    read_write = 2,
};
