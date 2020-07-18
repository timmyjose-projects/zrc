# zrc

A Zig egg (library) for calculating the `Adler-32` and `CRC-32` checksums of strings. 

An interface is also provided to extend the library with custom checksum algorithms.

## Usage

Example:

`adler32` checksum:

```
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = &arena.allocator;

    var string = "Hello, world";
    var cs_adler = adler32.Adler32().init(allocator);
    try cs_adler.checksum.updateByteArray(string[0..string.len]);
    testing.expect(cs_adler.checksum_value == 466879593);
    cs_adler.checksum.close();

```

`crc-32` checksum:

```
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = &arena.allocator;

    const string = "Hallo, Welt";
    var cs_crc32 = crc32.Crc32().init(allocator);

    for (string) |b| {
        try cs_crc32.checksum.updateByte(b);
    }
    testing.expect(cs_crc32.checksum_value == 1317902423);
    cs_adler.checksum.close();

```

See the tests in `src/lib.zig` for more usage details.

## LICENCE

See [LICENCE](LICENSE.md).