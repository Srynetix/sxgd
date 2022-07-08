# SxMath

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxMath.gd](../../extensions/SxMath.gd)|
|*Inherits from*|`Reference`|
|*Globally exported as*|`SxMath`|

## Static methods

### `lerp_vector3`

*Prototype*: `static func lerp_vector3(from: Vector3, to: Vector3, weight: float) -> Vector3`

> Lerp a Vector3 towards another using weight.  
>   
> Example:  
>   var vec3 := SxMath.lerp_vector3(vec1, vec2, 0.25)  
### `align_with_y`

*Prototype*: `static func align_with_y(transform: Transform, new_y: Vector3) -> Transform`

> Align a transform with a Y vector.  
>   
> Example:  
>   var xform := SxMath.align_with_y(transform, Vector3(1, 1, 1))  
### `interpolate_align_with_y`

*Prototype*: `static func interpolate_align_with_y(transform: Transform, new_y: Vector3, weight: float) -> Transform`

> Align a transform with a Y vector using interpolation.  
>   
> Example:  
>   var xform := SxMath.interpolate_align_with_y(transform, Vector3(1, 1, 1), 0.25)  
### `rand_range_i`

*Prototype*: `static func rand_range_i(from: int, to: int) -> int`

> Generate a random integer between two values.  
>   
> Example:  
>   var n := SxMath.rand_range_i(1, 2)  
### `rand_range_vec2`

*Prototype*: `static func rand_range_vec2(from: Vector2, to: Vector2) -> Vector2`

> Generate a random Vector2 between two values for each component.  
>   
> Example:  
>   var n := SxMath.rand_range_vec2(Vector2.ZERO, Vector2.ONE)  
### `map`

*Prototype*: `static func map(value: float, istart: float, istop: float, ostart: float, ostop: float) -> float`

> Map a float value from one set of bounds to another.  
>   
> Example:  
>   var n := SxMath.map(10, 0, 10, 0, 1)  
