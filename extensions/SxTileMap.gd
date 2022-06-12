extends Reference
class_name SxTileMap

# Helper class representing transpose/flip parameters for a TileMap cell
class CellRotationParams:
    extends Node

    var transpose: bool
    var flip_x: bool
    var flip_y: bool

    # Create params instance from arguments
    static func from_values(transpose: bool, flip_x: bool, flip_y: bool) -> CellRotationParams:
        var obj = CellRotationParams.new()
        obj.transpose = transpose
        obj.flip_x = flip_x
        obj.flip_y = flip_y
        return obj

    static func from_array(array: Array) -> CellRotationParams:
        return CellRotationParams.from_values(array[0], array[1], array[2])

    func to_array() -> Array:
        return [transpose, flip_x, flip_y]

class CellDump:
    extends Node

    var tile_id: int
    var tile_pos: Vector2
    var rotation_params: CellRotationParams

    static func from_values(tile_id: int, tile_pos: Vector2, rotation_params: CellRotationParams) -> CellDump:
        var obj = CellDump.new()
        obj.tile_id = tile_id
        obj.tile_pos = tile_pos
        obj.rotation_params = rotation_params
        return obj

    func to_array() -> Array:
        return [tile_id, [tile_pos.x, tile_pos.y], rotation_params.to_array()]

    static func from_array(array: Array) -> CellDump:
        return CellDump.from_values(array[0], Vector2(array[1][0], array[1][1]), CellRotationParams.from_array(array[2]))

# Get rotation for a specific cell, in radians.
#
# Example:
#   var r = SxTileMap.get_cell_rotation(tilemap, pos)
static func get_cell_rotation(tilemap: TileMap, pos: Vector2) -> float:
    var params = get_cell_rotation_params(tilemap, pos)
    return rotation_params_to_angle(params)

# Get rotation for a specific cell, in a custom class format.
static func get_cell_rotation_params(tilemap: TileMap, pos: Vector2) -> CellRotationParams:
    var x = int(pos.x)
    var y = int(pos.y)
    var transposed = tilemap.is_cell_transposed(x, y)
    var flip_x = tilemap.is_cell_x_flipped(x, y)
    var flip_y = tilemap.is_cell_y_flipped(x, y)

    return CellRotationParams.from_values(transposed, flip_x, flip_y)

# Convert rotation params to an angle in radians.
static func rotation_params_to_angle(params: CellRotationParams) -> float:
    var logger := SxLog.get_logger("SxTileMap")

    if !params.transpose && !params.flip_x && !params.flip_y:
        return 0.0

    if params.transpose && !params.flip_x && params.flip_y:
        return -PI / 2

    if !params.transpose && params.flip_x:
        return PI

    if params.transpose && params.flip_x && !params.flip_y:
        return PI / 2

    logger.warn(
        "Unknown rotation for params (t: %s, fx: %s, fy: %s)"
        % [params.transpose, params.flip_x, params.flip_y]
    )

    return 0.0

# Generate cell rotation parameters from an angle in degrees.
static func rotation_degrees_to_params(angle_degrees: int) -> CellRotationParams:
    assert(angle_degrees in [0, 90, 180, 270], "Unsupported angle %d in 'rotation_degrees_to_params'" % angle_degrees)

    if angle_degrees == 90:
        return CellRotationParams.from_values(true, true, false)
    elif angle_degrees == 180:
        return CellRotationParams.from_values(false, true, true)
    elif angle_degrees == 270:
        return CellRotationParams.from_values(true, false, true)
    else:
        return CellRotationParams.from_values(false, false, false)

# Create a dump from a tilemap.
static func create_dump(tilemap: TileMap) -> Array:
    var array = []
    for tile_pos in tilemap.get_used_cells():
        var tile_idx = tilemap.get_cellv(tile_pos)
        var params = get_cell_rotation_params(tilemap, tile_pos)
        array.append(CellDump.from_values(tile_idx, tile_pos, params).to_array())
    return array

# Apply a dump in a tilemap.
static func load_dump(tilemap: TileMap, array: Array) -> void:
    tilemap.clear()

    for item in array:
        var dump = CellDump.from_array(item)
        tilemap.set_cellv(dump.tile_pos, dump.tile_id, dump.rotation_params.flip_x, dump.rotation_params.flip_y, dump.rotation_params.transpose)
