extends TextureRect
class_name SxVirtualJoystick

# Joystick axis
enum Axis { Left = 0, Right, Up, Down }

const INITIAL_OPACITY := 0.5
const TOUCHED_OPACITY := 1.0

# On joystick change (with movement)
signal changed(movement)
# On joystick touch
signal touched()
# On joystick release
signal released()

# Action on left axis
export var action_axis_left: String
# Action on right axis
export var action_axis_right: String
# Action on up axis
export var action_axis_up: String
# Action on down axis
export var action_axis_down: String
# Dead zone
export var dead_zone := 0.3

onready var _head: TextureRect = $Head

onready var _initial_head_position := _head.rect_position
var _joystick_touch_index := -1
var _action_mapping := {}

func _ready():
    modulate = SxColor.with_alpha_f(Color.white, INITIAL_OPACITY)
    _head.modulate = SxColor.with_alpha_f(Color.white, INITIAL_OPACITY)
    _action_mapping = {
        Axis.Left: action_axis_left,
        Axis.Right: action_axis_right,
        Axis.Up: action_axis_up,
        Axis.Down: action_axis_down,
    }

func _input(event: InputEvent):
    if event is InputEventScreenTouch:
        var touch_event: InputEventScreenTouch = event
        if !touch_event.pressed && touch_event.index == _joystick_touch_index:
            _joystick_touch_index = -1
            _release()
        elif _joystick_touch_index == -1 && touch_event.pressed && get_global_rect().has_point(touch_event.position):
            _joystick_touch_index = touch_event.index
            _touch()

    elif event is InputEventScreenDrag:
        var drag_event: InputEventScreenDrag = event
        var base_rect_drag := get_global_rect().grow(2)
        if _joystick_touch_index != -1:  # && base_rect_drag.has_point(drag_event.position):
            var base_position := rect_global_position + rect_size / 2
            var mouse_base_vec := (drag_event.position - base_position).clamped(base_rect_drag.size.length() / 2)
            var force := mouse_base_vec / (rect_size / 2)

            # Move head
            _head.rect_position = (rect_size / 2 - _head.rect_size / 2) + (force * rect_size / 2)
            if abs(force.x) < dead_zone:
                force.x = 0
            if abs(force.y) < dead_zone:
                force.y = 0

            _move(force)

func _release() -> void:
    _head.rect_position = _initial_head_position
    modulate = SxColor.with_alpha_f(Color.white, INITIAL_OPACITY)
    _head.modulate = SxColor.with_alpha_f(Color.white, INITIAL_OPACITY)
    for k in _action_mapping:
        _send_joystick_event(k, 0)
    emit_signal("released")

func _touch() -> void:
    modulate = SxColor.with_alpha_f(Color.white, TOUCHED_OPACITY)
    _head.modulate = SxColor.with_alpha_f(Color.white, TOUCHED_OPACITY)
    emit_signal("touched")

func _move(force: Vector2) -> void:
    if force.x < 0:
        _send_joystick_event(Axis.Left, -force.x)
        _send_joystick_event(Axis.Right, 0)
    elif force.x > 0:
        _send_joystick_event(Axis.Left, 0)
        _send_joystick_event(Axis.Right, force.x)
    else:
        _send_joystick_event(Axis.Left, 0)
        _send_joystick_event(Axis.Right, 0)

    if force.y < 0:
        _send_joystick_event(Axis.Up, -force.y)
        _send_joystick_event(Axis.Down, 0)
    elif force.y > 0:
        _send_joystick_event(Axis.Up, 0)
        _send_joystick_event(Axis.Down, force.y)
    else:
        _send_joystick_event(Axis.Up, 0)
        _send_joystick_event(Axis.Down, 0)

    emit_signal("changed", force)

func _send_joystick_event(axis: int, value: float) -> void:
    var action_value: String = _action_mapping[axis]
    if action_value != "":
        if value > 0:
            Input.action_press(action_value, value)
        else:
            Input.action_release(action_value)
