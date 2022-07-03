# SxVirtualJoystick

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxVirtualJoystick.gd](../../../modules/SxVirtualControls/SxVirtualJoystick.gd)|
|*Inherits from*|`TextureRect`|
|*Globally exported as*|`SxVirtualJoystick`|

## Enums

### `Axis`

*Prototype*: `enum Axis { Left = 0, Right, Up, Down }`

> Joystick axis  
## Signals

### `changed`

*Code*: `signal changed(movement)`

> On joystick change (with movement)  
### `touched`

*Code*: `signal touched()`

> On joystick touch  
### `released`

*Code*: `signal released()`

> On joystick release  
## Exports

### `action_axis_left`

*Code*: `export var action_axis_left: String`

> Action on left axis  
### `action_axis_right`

*Code*: `export var action_axis_right: String`

> Action on right axis  
### `action_axis_up`

*Code*: `export var action_axis_up: String`

> Action on up axis  
### `action_axis_down`

*Code*: `export var action_axis_down: String`

> Action on down axis  
### `dead_zone`

*Code*: `export var dead_zone := 0.3`

> Dead zone  
