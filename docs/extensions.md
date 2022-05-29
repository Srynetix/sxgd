# Extensions

## SxColor - Color extensions
*Source*: [SxColor.gd](../extensions/SxColor.gd)

This extension exposes multiple static methods.

### Static methods

#### `with_alpha_f`
`SxColor.with_alpha_f(color: Color, alpha: float) -> Color`  
Apply a float alpha value on a color.

#### `with_alpha_i`
`SxColor.with_alpha_i(color: Color, alpha: int) -> Color`  
Apply an integer alpha value on a color.

#### `rand`
`SxColor.rand() -> Color`  
Generate a random color without transparency.

#### `rand_with_alpha_f`
`SxColor.rand_with_alpha_f(alpha: float) -> Color`  
Generate a random color with a float alpha value.

#### `rand_with_alpha_i`
`SxColor.rand_with_alpha_i(alpha: float) -> Color`  
Generate a random color with an integer alpha value.

## SxLog - Global logging facility
*Source*: [SxLog.gd](../extensions/SxLog.gd)

This extension (which is a kind of global node) allows to manipulate loggers with log levels (as in `Python`), with a global configuration mechanism based on a string value (as in `Rust`).

Six log levels are available, from lowest to highest: *TRACE*, *DEBUG*, *INFO*, *WARN*, *ERROR* and *CRITICAL*

### Static methods

#### `get_logger`
`SxLog.get_logger(name: String) -> Logger`  
Get or create a logger with a specific name.  
*Example*: `SxLog.get_logger("my_logger")`

#### `configure_log_levels`
`SxLog.configure_log_levels(conf: String) -> void`  
Configure log level for each loggers using a configuration string.  
*Example*: `SxLog.configure_log_levels("info,my_logger=debug")`

#### `set_max_log_level`
`SxLog.set_max_log_level(name: String, level: int) -> void`  
Set maximum log level for a specific logger.  
*Example*: `SxLog.set_max_log_level("my_logger", SxLog.LogLevel.ERROR)`

#### `trace`
`SxLog.trace(message: String, args: Array = []) -> void`  
Show a trace message on the root logger.

#### `debug`
`SxLog.debug(message: String, args: Array = []) -> void`  
Show a debug message on the root logger.

#### `info`
`SxLog.info(message: String, args: Array = []) -> void`  
Show an info message on the root logger.

#### `warn`
`SxLog.warn(message: String, args: Array = []) -> void`  
Show a warn message on the root logger.

#### `error`
`SxLog.error(message: String, args: Array = []) -> void`  
Show an error message on the root logger.

#### `critical`
`SxLog.critical(message: String, args: Array = []) -> void`  
Show a critical message on the root logger.

### `Logger` class, methods

#### `set_max_log_level`
`Logger.set_max_log_level(level: int) -> void`  
Set maximum log level on current logger.  
*Example*:

```
var my_logger = SxLog.get_logger("my_logger")
my_logger.set_max_log_level(SxLog.LogLevel.ERROR)
```

#### `trace`
`Logger.trace(message: String, args: Array = []) -> void`  
Show a trace message on current logger.

#### `debug`
`Logger.debug(message: String, args: Array = []) -> void`  
Show a debug message on current logger.

#### `info`
`Logger.info(message: String, args: Array = []) -> void`  
Show an info message on current logger.

#### `warn`
`Logger.warn(message: String, args: Array = []) -> void`  
Show a warn message on current logger.

#### `error`
`Logger.error(message: String, args: Array = []) -> void`  
Show an error message on current logger.

#### `critical`
`Logger.critical(message: String, args: Array = []) -> void`  
Show a critical message on current logger.

## SxMath - More math functions
*Source*: [SxMath.gd](../extensions/SxMath.gd)

This extension contains more specific math functions.

### Static methods

#### `lerp_vector3`
`SxMath.lerp_vector3(from: Vector3, to: Vector3, weight: float) -> Vector3`  
Apply `lerp` on a Vector3 towards another Vector3 using weight.  
*Example*: `var v = SxMath.lerp_vector3(Vector3(0, 0, 0), Vector3(1, 1, 1), 0.25)

#### `align_with_y`
`SxMath.align_with_y(transform: Transform, new_y: Vector3) -> Transform`  
Align a transform with a specific Y vector.  
*Example*: `var xform = SxMath.align_with_y(transform, Vector3(1, 1, 1))

#### `interpolate_align_with_y`
`SxMath.interpolate_align_with_y(transform: Transform, new_y: Vector3, weight: float) -> Transform`  
Align a transform with a specific Y vector using interpolation.  
*Example*: `var xform = SxMath.interpolate_align_with_y(transform, Vector3(1, 1, 1), 0.25)

#### `rand_range_i`
`SxMath.rand_range_i(from: int, to: int) -> int`  
Generate a random integer between two values.

#### `rand_range_vec2`
`SxMath.rand_range_vec2(from: Vector2, to: Vector2) -> Vector2`  
Generate a random Vector2 between two values for each component.

#### `map`
`SxMath.map(value: float, istart: float, istop: float, ostart: float, ostop: float) -> float`  
Map a float value from one set of bounds to another.  
*Example*: `var n = SxMath.map(10.0, 0.0, 10.0, 0.0, 1.0)`

## SxShader - Shader utilities
*Source*: [SxShader.gd](../extensions/SxShader.gd)

This extension exposes shader utilities.

### Static methods

#### `get_shader_param`
`SxShader.get_shader_param(item: CanvasItem, name: String)`  
Get a shader param from a canvas item, handling edge cases like missing material or non shader material.

#### `set_shader_param`
`SxShader.set_shader_param(item: CanvasItem, name: String) -> void`  
Set a shader param from a canvas item, handling edge cases like missing material or non shader material.

## SxText - Text utilities
*Source*: [SxText.gd](../extensions/SxText.gd)

This extension exposes text utilities.

### Static methods

#### `to_camel_case`
`SxText.to_camel_case(s: String) -> String`  
Convert a text to camel case (like helloWorld).  
*Example*: `var t = SxText.to_camel_case("hello_world") # => "helloWorld"`

#### `to_pascal_case`
`SxText.to_pascal_case(s: String) -> String`  
Convert a text to pascal case (like HelloWorld).  
*Example*: `var t = SxText.to_pascal_case("hello_world") # => "HelloWorld"`

## SxTileMap - Tilemap utilities
*Source*: [SxTileMap.gd](../extensions/SxTileMap.gd)

This extension exposes tilemap utilities.

### Static methods

#### `get_cell_rotation`
`SxTileMap.get_cell_rotation(tilemap: TileMap, pos: Vector2) -> float`  
Get rotation for a specific cell, in radians.  
*Example*: `var r = SxTileMap.get_cell_rotation(tilemap, Vector2(0, 0))`