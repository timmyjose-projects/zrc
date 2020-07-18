const std = @import("std");
const ArrayList = std.ArrayList;

/// The public interface for a Checksum type.
/// Any type that conforms to this interface can be plugged in as a
/// checksum provider:
///
/// The following functions are required for a custom provider:
///  - reset
///  - updateByte
///
/// The following have default implementations, which can be
/// overridden by providers:
///   - updateByteArray
///   - updateByteArrayRange
///   - updateByteBuffer
///
pub fn Checksum(comptime T: type) type {
    return struct {
        const Self = @This();
        pub const ByteBuffer = ArrayList(u8);

        reset_fn: fn (*Self) void,
        update_byte_fn: fn (*Self, u8) void,

        /// Reset the checksum to its initial value
        pub fn reset(self: *Self) !void {
            self.reset_fn(self);
        }

        /// Update the current checksum with the given
        /// byte.
        pub fn updateByte(self: *Self, b: u8) void {
            self.update_byte_fn(self, b);
        }

        /// Update the current checksum with the given
        /// byte array.
        /// default implementation
        pub fn updateByteArray(self: *Self, bs: []const u8) void {
            self.updateByteArrayRange(bs, 0, bs.len);
        }

        /// Update the current checksum with the (offset, offset + len) bytes from
        /// the given byte array.
        /// default implementation
        pub fn updateByteArrayRange(self: *Self, bs: []const u8, offset: usize, len: usize) void {
            // @TODO
        }

        /// Update the current checksum with the contents of the given
        /// byte buffer.
        /// default implementation
        pub fn updateByteBuffer(self: *Self, byte_buf: ByteBuffer) void {
            //@TODO
        }
    };
}
