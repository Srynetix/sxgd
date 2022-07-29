# SxFullScreenFileDialog

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxFullScreenFileDialog.gd](../../../../nodes/ui/SxFullScreenFileDialog/SxFullScreenFileDialog.gd)|
|*Inherits from*|`SxFullScreenDialog`|
|*Globally exported as*|`SxFullScreenFileDialog`|

## Enums

### `Mode`

*Prototype*: `enum Mode {`

## Signals

### `cancel`

*Code*: `signal cancel()`

### `file_selected`

*Code*: `signal file_selected(file)`

### `_item_doubleclicked`

*Code*: `signal _item_doubleclicked(file)`

## Exports

### `mode`

*Code*: `export(Mode) var mode := Mode.OPEN_FILE`

### `shortcuts`

*Code*: `export(Array, Dictionary) var shortcuts := []`

### `file_filter`

*Code*: `export var file_filter := ""`

## Methods

### `invalidate`

*Prototype*: `func invalidate() -> void`

## PathShortcut

|    |     |
|----|-----|
|*Inherits from*|`Node`|

### PathShortcut, Public variables

#### `name`

*Code*: `var name: String`

#### `path`

*Code*: `var path: String`

### PathShortcut, Static methods

#### `from_dict`

*Prototype*: `static func from_dict(d: Dictionary) -> PathShortcut`

