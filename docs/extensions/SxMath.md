# SxMath - More math functions

*Source*: [SxMath.gd](../../extensions/SxMath.gd)

This extension contains more specific math functions.

## Static methods

### `lerp_vector3`
`SxMath.lerp_vector3(from: Vector3, to: Vector3, weight: float) -> Vector3`  
Apply `lerp` on a Vector3 towards another Vector3 using weight.  
*Example*: `var v = SxMath.lerp_vector3(Vector3(0, 0, 0), Vector3(1, 1, 1), 0.25)

### `align_with_y`
`SxMath.align_with_y(transform: Transform, new_y: Vector3) -> Transform`  
Align a transform with a specific Y vector.  
*Example*: `var xform = SxMath.align_with_y(transform, Vector3(1, 1, 1))

### `interpolate_align_with_y`
`SxMath.interpolate_align_with_y(transform: Transform, new_y: Vector3, weight: float) -> Transform`  
Align a transform with a specific Y vector using interpolation.  
*Example*: `var xform = SxMath.interpolate_align_with_y(transform, Vector3(1, 1, 1), 0.25)

### `rand_range_i`
`SxMath.rand_range_i(from: int, to: int) -> int`  
Generate a random integer between two values.

### `rand_range_vec2`
`SxMath.rand_range_vec2(from: Vector2, to: Vector2) -> Vector2`  
Generate a random Vector2 between two values for each component.

### `map`
`SxMath.map(value: float, istart: float, istop: float, ostart: float, ostop: float) -> float`  
Map a float value from one set of bounds to another.  
*Example*: `var n = SxMath.map(10.0, 0.0, 10.0, 0.0, 1.0)`