const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const Checksum = @import("./checksum.zig").Checksum;

/// A checksum implementation - using the CRC-32 algorithm.
pub fn Crc32() type {
    return struct {
        const Self = @This();
        const ChecksumType = u32;
        const default_crc32_val = 0xffffffff;

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
                .checksum_value = default_crc32_val,
                .allocator = allocator,
            };
        }

        fn reset(checksum: *Checksum(ChecksumType)) void {
            const self = @fieldParentPtr(Self, "checksum", checksum);
            self.checksum_value = default_crc32_val;
            self.bytes.shrink(0);
        }

        fn close(checksum: *Checksum(ChecksumType)) void {
            const self = @fieldParentPtr(Self, "checksum", checksum);
            self.bytes.deinit();
        }

        /// Source: Hacker's Delight - Chapter 14 (CRC)
        fn updateByteArrayRange(checksum: *Checksum(ChecksumType), bs: []const u8, offset: usize, len: usize) !void {
            const self = @fieldParentPtr(Self, "checksum", checksum);

            for (bs[offset .. offset + len]) |b| {
                try self.bytes.append(b);
            }

            var crc: ChecksumType = default_crc32_val;
            for (self.bytes.items) |b| {
                crc = crc ^ @intCast(ChecksumType, b);
                var ctr: i32 = 7;
                while (ctr >= 0) : (ctr -= 1) {
                    var mask = -(@intCast(i64, crc) & 1);
                    crc = (crc >> 1) ^ @intCast(ChecksumType, 0xedb88320 & mask);
                }
            }

            self.checksum_value = ~crc;
        }
    };
}
