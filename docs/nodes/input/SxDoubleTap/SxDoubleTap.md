# SxDoubleTap

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxDoubleTap.gd](../../../../nodes/input/SxDoubleTap/SxDoubleTap.gd)|
|*Inherits from*|`Node`|
|*Globally exported as*|`SxDoubleTap`|

> Double tap detector  
## Signals

### `doubletap`

*Code*: `signal doubletap(touch_idx)`

## Exports

### `should_process_input`

*Code*: `export var should_process_input := true`

### `threshold_ms`

*Code*: `export var threshold_ms := 200`

## Methods

### `process_doubletap`

*Prototype*: `func process_doubletap(event: InputEvent) -> DoubleTapData`

## DoubleTapData

|    |     |
|----|-----|
|*Inherits from*|`Node`|

### DoubleTapData, Public variables

#### `result`

*Code*: `var result: bool`

#### `index`

*Code*: `var index: int`

#### `position`

*Code*: `var position: Vector2`

### DoubleTapData, Static methods

#### `none`

*Prototype*: `static func none() -> DoubleTapData`

#### `some`

*Prototype*: `static func some(index: int, position: Vector2) -> DoubleTapData`

