# SxSyncPeerInput

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxSyncPeerInput.gd](../../../nodes/networking/SxSyncPeerInput.gd)|
|*Inherits from*|`Node`|
|*Globally exported as*|`SxSyncPeerInput`|

## Methods

### `to_json`

*Prototype*: `func to_json() -> Dictionary`

### `update_from_json`

*Prototype*: `func update_from_json(input: Dictionary) -> void`

### `is_action_pressed`

*Prototype*: `func is_action_pressed(action_name: String) -> bool`

### `is_action_just_pressed`

*Prototype*: `func is_action_just_pressed(action_name: String) -> bool`

### `get_action_strength`

*Prototype*: `func get_action_strength(action_name: String) -> float`

### `query_input`

*Prototype*: `func query_input() -> void`

## InputState

|    |     |
|----|-----|
|*Inherits from*|`Node`|

### InputState, Public variables

#### `pressed`

*Code*: `var pressed := false`

#### `just_pressed`

*Code*: `var just_pressed := false`

#### `strength`

*Code*: `var strength := 0`

### InputState, Methods

#### `to_json`

*Prototype*: `func to_json() -> Dictionary`

#### `update_from_json`

*Prototype*: `func update_from_json(d: Dictionary) -> void`

