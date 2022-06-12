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
>   var r = SxTileMap.get_cell_rotation(tilemap, pos)  
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

*Prototype*: `static func create_dump(tilemap: TileMap) -> Array`

> Create a dump from a tilemap.  
### `load_dump`

*Prototype*: `static func load_dump(tilemap: TileMap, array: Array) -> void`

> Apply a dump in a tilemap.  
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
#### `from_array`

*Prototype*: `static func from_array(array: Array) -> CellRotationParams`

### CellRotationParams, Methods

#### `to_array`

*Prototype*: `func to_array() -> Array`

## CellDump

|    |     |
|----|-----|
|*Inherits from*|`Node`|

### CellDump, Public variables

#### `tile_id`

*Code*: `var tile_id: int`

#### `tile_pos`

*Code*: `var tile_pos: Vector2`

#### `rotation_params`

*Code*: `var rotation_params: CellRotationParams`

### CellDump, Static methods

#### `from_values`

*Prototype*: `static func from_values(tile_id: int, tile_pos: Vector2, rotation_params: CellRotationParams) -> CellDump`

#### `from_array`

*Prototype*: `static func from_array(array: Array) -> CellDump`

### CellDump, Methods

#### `to_array`

*Prototype*: `func to_array() -> Array`

