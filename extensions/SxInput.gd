extends Object
class_name SxInput

# Get the joystick movement as a `Vector2` from four joystick actions in the `Input Map`.
# You need to define **four** joystick actions, each _ending with its direction_.
#
# For example, if you want to handle a joystick action named `move`, you need to register:
# - `move_left`, `move_right`, `move_up`, `move_down`
#
# Or if your joystick action is named `aim`:
# - `aim_left`, `aim_right`, `aim_up`, `aim_down`
#
# Example:
# ```gdscript
# var movement := SxInput.get_joystick_movement("aim")
# ```
static func get_joystick_movement(action_name: String) -> Vector2:
    var directions := ["left", "right", "up", "down"]
    var forces := [0, 0, 0, 0]
    for i in range(len(directions)):
        var dir := directions[i] as String
        forces[i] = Input.get_action_strength("%s_%s" % [action_name, dir])

    var movement := Vector2()
    movement.x -= forces[0]
    movement.x += forces[1]
    movement.y -= forces[2]
    movement.y += forces[3]
    return movement.normalized()
