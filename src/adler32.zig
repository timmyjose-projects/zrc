const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const Checksum = @import("./checksum.zig").Checksum;

/// A checksum implementation - using the Adler-32 algorithm.
pub fn Adler32() type {
    return struct {
        const Self = @This();
        const ChecksumType = u32;
        const PRIME_MOD = 65521;
        const default_adler32_val = 0;

        bytes: ArrayList(u8),
        checksum: Checksum(ChecksumType),
        checksum_value: ChecksumType,
        allocator: *Allocator,

        pub fn init(allocator: *Allocator) Self {
            return Self{
                .bytes = ArrayList(u8).init(allocator),
                .checksum = Checksum(ChecksumType){
                    .reset_fn = reset,
                    .update_byte_array_range_fn = updateByteArrayRange,
                    .close_fn = close,
                },
                .checksum_value = default_adler32_val,
                .allocator = allocator,
            };
        }

        fn reset(checksum: *Checksum(ChecksumType)) void {
            const self = @fieldParentPtr(Self, "checksum", checksum);
            self.checksum_value = default_adler32_val;
            self.bytes.shrink(0);
        }

        fn close(checksum: *Checksum(ChecksumType)) void {
            const self = @fieldParentPtr(Self, "checksum", checksum);
            self.bytes.deinit();
        }

        /// Simple, unoptimised implementation
        fn updateByteArrayRange(checksum: *Checksum(ChecksumType), bs: []const u8, offset: usize, len: usize) !void {
            const self = @fieldParentPtr(Self, "checksum", checksum);

            for (bs[offset .. offset + len]) |b| {
                try self.bytes.append(b);
            }

            var r: ChecksumType = 1;
            var s: ChecksumType = 0;
            for (self.bytes.items) |b| {
                r = @mod(r + b, PRIME_MOD);
                s = @mod(r + s, PRIME_MOD);
            }

            self.checksum_value = (s << 16) | r;
        }
    };
}
