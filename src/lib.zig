const std = @import("std");
const Allocator = std.mem.Allocator;
const testing = std.testing;
const adler32 = @import("./adler32.zig");
const crc32 = @import("./crc-32.zig");

test "adler32 - updateByteArray" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = &arena.allocator;

    var string = "Hello, world";
    var cs_adler = adler32.Adler32().init(allocator);
    try cs_adler.checksum.updateByteArray(string[0..string.len]);
    testing.expect(cs_adler.checksum_value == 466879593);
}

test "adler32 - updateByteArrayRange" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = &arena.allocator;

    var string = "Hola, mundo!";
    var cs_adler = adler32.Adler32().init(allocator);
    try cs_adler.checksum.updateByteArrayRange(string, 0, string.len);
    testing.expect(cs_adler.checksum_value == 449578005);

    cs_adler.checksum.reset();
    try cs_adler.checksum.updateByteArrayRange(string, 0, 5);
    try cs_adler.checksum.updateByteArrayRange(string, 5, string.len - 5);
    std.debug.print("{}\n", .{cs_adler.checksum_value});
    testing.expect(cs_adler.checksum_value == 449578005);
}

test "adler32 - updateByte" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = &arena.allocator;

    var string = "Hallo, Welt";
    var cs_adler = adler32.Adler32().init(allocator);
    for (string) |b| {
        try cs_adler.checksum.updateByte(b);
    }
    testing.expect(cs_adler.checksum_value == 379651033);
}

test "crc-32 - updateByteArray" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = &arena.allocator;

    const string = "Hello, world";
    var cs_crc32 = crc32.Crc32().init(allocator);
    try cs_crc32.checksum.updateByteArray(string[0..string.len]);
    testing.expect(cs_crc32.checksum_value == 3885672898);
}

test "crc-32 - updateByteArrayRange" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = &arena.allocator;

    const string = "Hola, mundo!";
    var cs_crc32 = crc32.Crc32().init(allocator);
    try cs_crc32.checksum.updateByteArrayRange(string, 0, string.len);
    testing.expect(cs_crc32.checksum_value == 3494030786);

    cs_crc32.checksum.reset();
    try cs_crc32.checksum.updateByteArrayRange(string, 0, 10);
    try cs_crc32.checksum.updateByteArrayRange(string, 10, string.len - 10);
}

test "crc-32 - updateByte" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = &arena.allocator;

    const string = "Hallo, Welt";
    var cs_crc32 = crc32.Crc32().init(allocator);

    for (string) |b| {
        try cs_crc32.checksum.updateByte(b);
    }
    testing.expect(cs_crc32.checksum_value == 1317902423);
}
