# SxTileMap - Tilemap utilities

*Source*: [SxTileMap.gd](../../extensions/SxTileMap.gd)

This extension exposes tilemap utilities.

## Static methods

### `get_cell_rotation`
`SxTileMap.get_cell_rotation(tilemap: TileMap, pos: Vector2) -> float`  
Get rotation for a specific cell, in radians.  
*Example*: `var r = SxTileMap.get_cell_rotation(tilemap, Vector2(0, 0))`