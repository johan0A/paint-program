const std = @import("std");

const Self = @This();

string: std.ArrayListUnmanaged(u8),
allocator: std.mem.Allocator,

pub fn init(allocator: std.mem.Allocator) !Self {
    var result = Self{
        .string = std.ArrayListUnmanaged(u8){},
        .allocator = allocator,
    };
    try result.string.append(allocator, 0);
    return result;
}

pub fn deinit(self: *Self) void {
    self.string.deinit(self.allocator);
}

pub fn replace(self: *Self, str: []const u8) !void {
    if (self.string.items.len > 0) self.string.shrinkAndFree(self.allocator, 0);
    try self.append(str);
}

pub fn getNullTerminated(self: *Self) [*:0]u8 {
    const slice = self.string.items[0..self.string.items.len];
    const null_terminated: [*:0]u8 = @ptrCast(slice);
    return null_terminated;
}

pub fn get(self: *Self) []u8 {
    if (self.string.items.len == 0) return "";
    return self.string.items[0 .. self.string.items.len - 1];
}

pub fn append(self: *Self, str: []const u8) !void {
    _ = self.string.popOrNull();
    try self.string.appendSlice(self.allocator, str);
    try self.string.append(self.allocator, 0);
}
