tool
extends TextureRect
class_name SxVirtualButton

const INITIAL_OPACITY := 0.5
const TOUCHED_OPACITY := 1.0

# On button touc
signal touched()
# On button release
signal released()

# Action button
export var action_button: String

var _button_touch_index := -1

func _ready() -> void:
    modulate = SxColor.with_alpha_f(Color.white, INITIAL_OPACITY)

func _input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        var touch_event := event as InputEventScreenTouch
        if !touch_event.pressed && touch_event.index == _button_touch_index:
            _button_touch_index = -1
            modulate = SxColor.with_alpha_f(Color.white, INITIAL_OPACITY)
            _send_button_event(false)
            emit_signal("released")
        elif _button_touch_index == -1 && touch_event.pressed && get_global_rect().has_point(touch_event.position):
            _button_touch_index = touch_event.index
            modulate = SxColor.with_alpha_f(Color.white, TOUCHED_OPACITY)
            _send_button_event(true)
            emit_signal("touched")

func _send_button_event(pressed: bool):
    if action_button != "":
        if pressed:
            Input.action_press(action_button)
        else:
            Input.action_release(action_button)
