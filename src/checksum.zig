const ArrayList = std.ArrayList;

/// The public interface for a Checksum type.
/// Any type that conforms to this interface can be plugged in as a
/// checksum provider:
///
/// The following functions are required for a custom provider:
///  - reset
///  - updateByteArrayRange
///  - close
///
/// The following have default implementations, which can be
/// overridden by providers:
///   - updateByte
///   - updateByteArray
///
pub fn Checksum(comptime T: type) type {
    return struct {
        const Self = @This();
        pub const ByteBuffer = ArrayList(u8);

        reset_fn: fn (*Self) void,
        update_byte_array_range_fn: fn (*Self, []const u8, usize, usize) anyerror!void,
        close_fn: fn (*Self) void,

        /// Reset the checksum to its initial value
        pub fn reset(self: *Self) void {
            self.reset_fn(self);
        }

        /// Update the current checksum with the (offset, offset + len) bytes from
        /// the given byte array.
        pub fn updateByteArrayRange(self: *Self, bs: []const u8, offset: usize, len: usize) !void {
            try self.update_byte_array_range_fn(self, bs, offset, len);
        }

        /// Update the current checksum with the given
        /// byte.
        /// default implementation
        pub fn updateByte(self: *Self, b: u8) !void {
            try self.updateByteArrayRange(&[_]u8{b}, 0, 1);
        }

        /// Update the current checksum with the given
        /// byte array.
        /// default implementation
        pub fn updateByteArray(self: *Self, bs: []const u8) !void {
            try self.updateByteArrayRange(bs, 0, bs.len);
        }

        pub fn close(self: *Self) void {
            self.close_fn(self);
        }
    };
}
