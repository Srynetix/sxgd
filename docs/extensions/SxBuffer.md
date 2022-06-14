# SxBuffer

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxBuffer.gd](../../extensions/SxBuffer.gd)|
|*Inherits from*|`Reference`|
|*Globally exported as*|`SxBuffer`|

## Static methods

### `zstd_compress`

*Prototype*: `static func zstd_compress(array: PoolByteArray) -> PoolByteArray`

> Compress a byte array using zstd, adding original content size at the beginning.  
> The content size is needed for Godot to decompress, so the resulting byte array  
> is not valid zstd compressed data.  
> To have a valid zstd compressed data, you need to strip the first 64 bits.  
### `zstd_decompress`

*Prototype*: `static func zstd_decompress(array: PoolByteArray) -> PoolByteArray`

> Decompress a byte array generated with `zstd_compress`.  
> It is not usable with zstd compressed data generated elsewhere, because it expects  
> a 64 bit integer at first representing the original data size (needed for Godot).  
