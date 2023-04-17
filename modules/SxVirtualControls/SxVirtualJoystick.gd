@tool
extends TextureRect
class_name SxVirtualJoystick

const BACKGROUND_TEXTURE := preload("res://addons/sxgd/modules/SxVirtualControls/assets/textures/transparentDark/transparentDark05.png")
const HEAD_TEXTURE := preload("res://addons/sxgd/modules/SxVirtualControls/assets/textures/transparentDark/transparentDark49.png")

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
@export var action_axis_left: String
# Action on right axis
@export var action_axis_right: String
# Action on up axis
@export var action_axis_up: String
# Action on down axis
@export var action_axis_down: String
# Dead zone
@export var dead_zone := 0.3

var _initial_head_position: Vector2
var _head: TextureRect
var _joystick_touch_index := -1
var _action_mapping := {}

func _ready():
    modulate = SxColor.with_alpha_f(Color.WHITE, INITIAL_OPACITY)
    _action_mapping = {
        Axis.Left: action_axis_left,
        Axis.Right: action_axis_right,
        Axis.Up: action_axis_up,
        Axis.Down: action_axis_down,
    }

    if custom_minimum_size == Vector2.ZERO:
        custom_minimum_size = Vector2(128, 128)
    if !size_flags_horizontal:
        size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    if !size_flags_vertical:
        size_flags_vertical = Control.SIZE_SHRINK_CENTER
    texture = BACKGROUND_TEXTURE
    expand_mode = TextureRect.EXPAND_IGNORE_SIZE

    _head = TextureRect.new()
    _head.anchor_left = 0.5
    _head.anchor_top = 0.5
    _head.anchor_right = 0.5
    _head.anchor_bottom = 0.5
    _head.custom_minimum_size = Vector2(64, 64)
    _head.offset_left = -_head.custom_minimum_size.x / 2
    _head.offset_right = _head.custom_minimum_size.x / 2
    _head.offset_top = -_head.custom_minimum_size.y / 2
    _head.offset_bottom = _head.custom_minimum_size.y / 2
    _head.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    _head.size_flags_vertical = Control.SIZE_SHRINK_CENTER
    _head.texture = HEAD_TEXTURE
    _head.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    _head.modulate = SxColor.with_alpha_f(Color.WHITE, INITIAL_OPACITY)
    add_child(_head)

    # Wait a little to make sure the initial head position is the right one
    await get_tree().process_frame
    _initial_head_position = _head.position

func _input(event: InputEvent):
    if event is InputEventScreenTouch:
        var touch_event := event as InputEventScreenTouch
        if !touch_event.pressed && touch_event.index == _joystick_touch_index:
            _joystick_touch_index = -1
            _release()
        elif _joystick_touch_index == -1 && touch_event.pressed && get_global_rect().has_point(touch_event.position):
            _joystick_touch_index = touch_event.index
            _touch()

    elif event is InputEventScreenDrag:
        var drag_event := event as InputEventScreenDrag
        var base_rect_drag := get_global_rect().grow(2)
        if _joystick_touch_index != -1:  # && base_rect_drag.has_point(drag_event.position):
            var base_position := global_position + size / 2
            var mouse_base_vec := (drag_event.position - base_position).limit_length(base_rect_drag.size.length() / 2)
            var force := mouse_base_vec / (size / 2)

            # Move head
            _head.position = (size / 2 - _head.size / 2) + (force * size / 2)
            if abs(force.x) < dead_zone:
                force.x = 0
            if abs(force.y) < dead_zone:
                force.y = 0

            _move(force)

func _release() -> void:
    _head.position = _initial_head_position
    modulate = SxColor.with_alpha_f(Color.WHITE, INITIAL_OPACITY)
    _head.modulate = SxColor.with_alpha_f(Color.WHITE, INITIAL_OPACITY)
    for k in _action_mapping:
        _send_joystick_event(k, 0)
    emit_signal(released.get_name())

func _touch() -> void:
    modulate = SxColor.with_alpha_f(Color.WHITE, TOUCHED_OPACITY)
    _head.modulate = SxColor.with_alpha_f(Color.WHITE, TOUCHED_OPACITY)
    emit_signal(touched.get_name())

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
    var action_value := _action_mapping[axis] as String
    if action_value != "":
        if value > 0:
            Input.action_press(action_value, value)
        else:
            Input.action_release(action_value)
