extends Node
class_name SxDoubleTap
## Double tap detector.

## On double tap.
signal doubletap(touch_idx)

## Should process input.
@export var should_process_input := true
## Threshold in milliseconds.
@export var threshold_ms := 200
## Target rectangle.
@export var target_rect: Rect2

var _time_per_touch := {}

## Represents double tap data.
class DoubleTapData:
    ## Double tap detected?
    var result: bool
    ## Tap index.
    var index: int
    ## Tap position.
    var position: Vector2

    ## Build an empty double tap data.
    static func none() -> DoubleTapData:
        var value := DoubleTapData.new()
        value.result = false
        value.index = 0
        value.position = Vector2.ZERO
        return value

    ## Build a detected double tap data.
    static func some(index: int, position: Vector2) -> DoubleTapData:
        var value := DoubleTapData.new()
        value.result = true
        value.index = index
        value.position = position
        return value

## Try to detect a double tap from an [InputEvent].
func process_doubletap(event: InputEvent) -> DoubleTapData:
    var result = DoubleTapData.none()

    if event is InputEventScreenTouch:
        var touch_event := event as InputEventScreenTouch
        var touch_idx := touch_event.index
        if touch_event.pressed && _touch_in_rect(touch_event.position):
            var this_time := Time.get_ticks_msec()
            if _time_per_touch.has(touch_idx):
                var last_time := _time_per_touch[touch_idx] as int
                if this_time - last_time <= threshold_ms:
                    result = DoubleTapData.some(touch_idx, touch_event.position)
            _time_per_touch[touch_idx] = this_time

    return result

func _ready() -> void:
    set_process_input(should_process_input)

func _input(event: InputEvent) -> void:
    var has_doubletap := process_doubletap(event)
    if has_doubletap.result:
        emit_signal("doubletap", has_doubletap.index)

func _touch_in_rect(touch_position: Vector2) -> bool:
    if target_rect:
        return target_rect.has_point(touch_position)
    return true
