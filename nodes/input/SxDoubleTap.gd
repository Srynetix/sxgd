# Double tap detector

extends Node
class_name SxDoubleTap

signal doubletap(touch_idx)

export var should_process_input := true
export var threshold_ms := 200

var _time_per_touch := {}

class DoubleTapData:
    var result: bool
    var index: int
    var position: Vector2

    static func none() -> DoubleTapData:
        var value := DoubleTapData.new()
        value.result = false
        value.index = 0
        value.position = Vector2.ZERO
        return value

    static func some(index: int, position: Vector2) -> DoubleTapData:
        var value := DoubleTapData.new()
        value.result = true
        value.index = index
        value.position = position
        return value

func _ready() -> void:
    set_process_input(should_process_input)

func _input(event: InputEvent) -> void:
    var has_doubletap := process_doubletap(event)
    if has_doubletap.result:
        emit_signal("doubletap", has_doubletap.index)

func process_doubletap(event: InputEvent) -> DoubleTapData:
    var result = DoubleTapData.none()

    if event is InputEventScreenTouch:
        var touch_event := event as InputEventScreenTouch
        var touch_idx := touch_event.index
        if touch_event.pressed:
            var this_time := OS.get_ticks_msec()
            if _time_per_touch.has(touch_idx):
                var last_time := _time_per_touch[touch_idx] as int
                if this_time - last_time <= threshold_ms:
                    result = DoubleTapData.some(touch_idx, touch_event.position)
            _time_per_touch[touch_idx] = this_time

    return result
