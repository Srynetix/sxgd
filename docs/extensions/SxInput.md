# SxInput

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxInput.gd](../../extensions/SxInput.gd)|
|*Inherits from*|`Reference`|
|*Globally exported as*|`SxInput`|

## Static methods

### `get_joystick_movement`

*Prototype*: `static func get_joystick_movement(action_name: String) -> Vector2`

> Get the joystick movement as a `Vector2` from four joystick actions in the `Input Map`.  
> You need to define **four** joystick actions, each _ending with its direction_.  
>   
> For example, if you want to handle a joystick action named `move`, you need to register:  
> - `move_left`, `move_right`, `move_up`, `move_down`  
>   
> Or if your joystick action is named `aim`:  
> - `aim_left`, `aim_right`, `aim_up`, `aim_down`  
>   
> Example:  
> ```gdscript  
> var movement = SxInput.get_joystick_movement("aim")  
> ```  
