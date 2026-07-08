const errno = @import("errno.zig");

pub const Fd = struct {
    fd: i32,
};

pub const SocketType = enum(c_int) {
    stream = 1,
    dgram = 2,
    raw = 3,
};

pub const AddressFamily = enum(c_int) {
    inet = 2,
    inet6 = 10,
    unix = 1,
};

pub const Protocol = enum(c_int) {
    tcp = 6,
    udp = 17,
};
