# SxTileMap

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxTileMap.gd](../../extensions/SxTileMap.gd)|
|*Inherits from*|`Reference`|
|*Globally exported as*|`SxTileMap`|

## Static methods

### `get_cell_rotation`

*Prototype*: `static func get_cell_rotation(tilemap: TileMap, pos: Vector2) -> float`

> Get rotation for a specific cell, in radians.  
>   
> Example:  
>   var r := SxTileMap.get_cell_rotation(tilemap, pos)  
### `get_cell_rotation_params`

*Prototype*: `static func get_cell_rotation_params(tilemap: TileMap, pos: Vector2) -> CellRotationParams`

> Get rotation for a specific cell, in a custom class format.  
### `rotation_params_to_angle`

*Prototype*: `static func rotation_params_to_angle(params: CellRotationParams) -> float`

> Convert rotation params to an angle in radians.  
### `rotation_degrees_to_params`

*Prototype*: `static func rotation_degrees_to_params(angle_degrees: int) -> CellRotationParams`

> Generate cell rotation parameters from an angle in degrees.  
### `create_dump`

*Prototype*: `static func create_dump(tilemap: TileMap) -> PoolIntArray`

> Create a dump from tilemap contents.  
### `apply_dump`

*Prototype*: `static func apply_dump(tilemap: TileMap, array: PoolIntArray) -> void`

> Overwrite tilemap contents with a dump.  
## CellRotationParams

|    |     |
|----|-----|
|*Inherits from*|`Node`|

> Helper class representing transpose/flip parameters for a TileMap cell  
### CellRotationParams, Public variables

#### `transpose`

*Code*: `var transpose: bool`

#### `flip_x`

*Code*: `var flip_x: bool`

#### `flip_y`

*Code*: `var flip_y: bool`

### CellRotationParams, Static methods

#### `from_values`

*Prototype*: `static func from_values(transpose: bool, flip_x: bool, flip_y: bool) -> CellRotationParams`

> Create params instance from arguments  
