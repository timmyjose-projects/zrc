const Checksum = @import("./checksum.zig").Checksum;

/// A checksum implementation - using the Adler-32 algorithm.
pub fn Adler32() type {
    return struct {
        const Self = @This();
        const ChecksumType = u32;

        bytes: []const u8,
        checksum: Checksum(ChecksumType),
        checksum_value: ?ChecksumType,

        pub fn init() Self {
            return Self{
                .bytes = undefined,
                .checksum = Checksum(ChecksumType){
                    .reset_fn = reset,
                    .update_byte_fn = updateByte,
                },
                .checksum_value = null,
            };
        }

        fn reset(checksum: *Checksum(ChecksumType)) void {
            const self = @fieldParentPtr(Self, "checksum", checksum);
        }

        fn updateByte(checksum: *Checksum(ChecksumType), b: u8) void {
            const self = @fieldParentPtr(Self, "checksum", checksum);
        }
    };
}
