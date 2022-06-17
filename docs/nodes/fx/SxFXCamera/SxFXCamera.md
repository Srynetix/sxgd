# SxFXCamera

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxFXCamera.gd](../../../../nodes/fx/SxFXCamera/SxFXCamera.gd)|
|*Inherits from*|`Camera2D`|
|*Globally exported as*|`SxFXCamera`|

## Enums

### `Direction`

*Prototype*: `enum Direction {`

## Exports

### `max_shake_strength`

*Code*: `export var max_shake_strength: float = 2`

### `shake_ratio`

*Code*: `export var shake_ratio: float = 0`

## Methods

### `tween_to_position`

*Prototype*: `func tween_to_position(position: Vector2, speed: float = 0.5, zoom: float = 1, easing: int = Tween.TRANS_QUAD) -> void`

> Tween to a specific position  
>   
> Example:  
>   camera.tween_to_position(Vector2(100, 100))  
### `viewport_scroll`

*Prototype*: `func viewport_scroll(top_left: Vector2, direction: int, speed: float = 0.65, easing: int = Tween.TRANS_QUAD) -> void`

> Apply a viewport scroll effect.  
>   
> Example:  
>   camera.viewport_scroll(Vector2(0, 0), Direction.RIGHT)  
### `reset_limits`

*Prototype*: `func reset_limits()`

> Reset the camera limits to an arbitrary large number.  
