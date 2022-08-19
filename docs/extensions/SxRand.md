# SxRand

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxRand.gd](../../extensions/SxRand.gd)|
|*Inherits from*|`Reference`|
|*Globally exported as*|`SxRand`|

> Random helpers.  
## Static methods

### `range_i`

*Prototype*: `static func range_i(from: int, to: int) -> int`

> Generate a random integer between two values.  
>   
> Example:  
>   var n := SxRand.range_i(1, 2)  
### `range_vec2`

*Prototype*: `static func range_vec2(from: Vector2, to: Vector2) -> Vector2`

> Generate a random Vector2 between two values for each component.  
>   
> Example:  
>   var n := SxRand.range_vec2(Vector2.ZERO, Vector2.ONE)  
### `chance_bool`

*Prototype*: `static func chance_bool(chance: int) -> bool`

> Generate a random boolean following a chance percentage.  
>   
> Example:  
>   var n := SxRand.chance_bool(75)  
### `choice_array`

*Prototype*: `static func choice_array(array: Array)`

> Choose a random value from an array.  
>   
> Example:  
>   var v = SxRand.choice_array(75)  
