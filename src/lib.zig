const std = @import("std");
const testing = std.testing;
const adler32 = @import("./adler32.zig");
const crc32 = @import("./crc-32.zig");

test "adler32" {
    var string = "Hello, world";
    var cs_adler = adler32.Adler32().init();
    cs_adler.checksum.updateByteArray(string[0..string.len]);
    if (cs_adler.checksum_value) |cs| {
        testing.expect(cs == 3885672898);
    }
}

test "crc-32" {
    const string = "Hello, world";
    var cs_crc32 = crc32.Crc32().init();
    cs_crc32.checksum.updateByteArray(string[0..string.len]);
    if (cs_crc32.checksum_value) |cs| {
        testing.expect(cs == 146687959);
    }
}
