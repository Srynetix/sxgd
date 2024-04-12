extends Object
class_name SxBuffer
## Buffer extensions.
##
## Additional methods to work with buffers.

## Compress a byte array using zstd, adding original content size at the beginning.
## The content size is needed for Godot to decompress, so the resulting byte array
## is not valid zstd compressed data.
## To have a valid zstd compressed data, you need to strip the first 64 bits.
static func zstd_compress(array: PackedByteArray) -> PackedByteArray:
    var size := len(array)
    var compressed := array.compress(FileAccess.COMPRESSION_ZSTD)

    var out_buffer := StreamPeerBuffer.new()
    out_buffer.put_64(size)
    out_buffer.put_data(compressed)
    return out_buffer.data_array

## Decompress a byte array generated with `zstd_compress`.
## It is not usable with zstd compressed data generated elsewhere, because it expects
## a 64 bit integer at first representing the original data size (needed for Godot).
static func zstd_decompress(array: PackedByteArray) -> PackedByteArray:
    var buffer := StreamPeerBuffer.new()
    buffer.data_array = array

    var orig_size := buffer.get_64()
    var remaining_data_a := buffer.get_data(buffer.get_size() - buffer.get_position())
    var compressed := remaining_data_a[1] as PackedByteArray
    return compressed.decompress(orig_size, FileAccess.COMPRESSION_ZSTD)
