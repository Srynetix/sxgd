extends Reference
class_name SxTileMap

# Get rotation for a specific cell, in radians.
#
# Example:
#   var r = SxTileMap.get_cell_rotation(tilemap, pos)
static func get_cell_rotation(tilemap: TileMap, pos: Vector2) -> float:
    var logger := SxLog.get_logger("SxTileMap")

    var x = int(pos.x)
    var y = int(pos.y)
    var transposed = tilemap.is_cell_transposed(x, y)
    var flip_x = tilemap.is_cell_x_flipped(x, y)
    var flip_y = tilemap.is_cell_y_flipped(x, y)

    if !transposed && !flip_x && !flip_y:
        return 0.0

    if transposed && !flip_x && flip_y:
        return -PI / 2

    if !transposed && flip_x:
        return PI

    if transposed && flip_x && !flip_y:
        return PI / 2

    logger.warn(
        "Unknown rotation for map %s, position %s (t: %s, fx: %s, fy: %s)"
        % [tilemap, pos, transposed, flip_x, flip_y]
    )

    return 0.0
