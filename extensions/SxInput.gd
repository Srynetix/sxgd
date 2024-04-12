extends Object
class_name SxInput
## Input extensions.
##
## Additional methods to work with inputs.

static var _disabled: bool = false

## Get the joystick movement as a [Vector2] from four joystick actions in the [InputMap].[br]
##
## You need to define [b]four[/b] joystick actions, each [i]ending with its direction[i].[br]
##
## For example, if you want to handle a joystick action named [code]move[code], you need to register:[br]
## - [code]move_left[/code], [code]move_right[/code], [code]move_up[/code], [code]move_down[/code][br]
##
## Or if your joystick action is named [code]aim[/code]:[br]
## - [code]aim_left[/code], [code]aim_right[/code], [code]aim_up[/code], [code]aim_down[/code][br]
##
## Usage:
## [codeblock]
## var movement := SxInput.get_joystick_movement("aim")
## [/codeblock]
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

## Disable input actions.[br]
##
## Will only disable input actions queried with [SxInput] (and not with the builtin [Input])
static func set_input_disabled(value: bool):
    _disabled = value

## Check if action is pressed.
static func is_action_pressed(action: String) -> bool:
    if _disabled:
        return false

    return Input.is_action_pressed(action)

## Check if action is just pressed.
static func is_action_just_pressed(action: String) -> bool:
    if _disabled:
        return false

    return Input.is_action_just_pressed(action)

## Check if action is just released.
static func is_action_just_released(action: String) -> bool:
    if _disabled:
        return false

    return Input.is_action_just_released(action)

## Get action strength.
static func get_action_strength(action: String, exact_match: bool = false) -> float:
    if _disabled:
        return false

    return Input.get_action_strength(action, exact_match)

## Get axis.
static func get_axis(negative_action: String, positive_action: String) -> float:
    if _disabled:
        return false

    return Input.get_axis(negative_action, positive_action)
