extends Camera2D
class_name SxFXCamera

enum Direction {
    LEFT = 0,
    RIGHT,
    UP,
    DOWN
}

export var max_shake_strength: float = 2
export var shake_ratio: float = 0

onready var tween: Tween = $Tween

func _process(delta) -> void:
    _update_shake()

func _update_shake() -> void:
    var coef := rand_range(-1, 1) * max_shake_strength * shake_ratio
    offset = Vector2(coef, coef)

# Tween to a specific position
#
# Example:
#   camera.tween_to_position(Vector2(100, 100))
func tween_to_position(position: Vector2, speed: float = 0.5, zoom_: float = 1, easing: int = Tween.TRANS_QUAD) -> void:
    tween.stop_all()
    tween.interpolate_property(self, "global_position", global_position, position, speed, easing, Tween.EASE_IN_OUT)
    tween.interpolate_property(self, "zoom", zoom, Vector2.ONE * zoom, speed, easing, Tween.EASE_IN_OUT)
    tween.start()

    yield(tween, "tween_all_completed")

# Apply a viewport scroll effect.
#
# Example:
#   camera.viewport_scroll(Vector2(0, 0), Direction.RIGHT)
func viewport_scroll(top_left: Vector2, direction: int, speed: float = 0.65, easing: int = Tween.TRANS_QUAD) -> void:
    var vp_size := get_viewport_rect().size
    tween.stop_all()

    reset_limits()
    var start_position := top_left + vp_size / 2
    var end_position := _add_viewport_size_to_position(top_left, direction)
    global_position = start_position

    tween.interpolate_property(self, "global_position", start_position, end_position, speed, easing, Tween.EASE_IN_OUT)
    tween.start()
    yield(tween, "tween_all_completed")

    limit_left = end_position.x - vp_size.x / 2
    limit_right = limit_left + vp_size.x
    limit_top = end_position.y - vp_size.y / 2
    limit_bottom = limit_top + vp_size.y
    smoothing_enabled = true

# Reset the camera limits to an arbitrary large number.
func reset_limits():
    limit_left = -1000000
    limit_right = 1000000
    limit_top = -1000000
    limit_bottom = 1000000
    smoothing_enabled = false

func _add_viewport_size_to_position(top_left: Vector2, direction: int) -> Vector2:
    var vp_size := get_viewport_rect().size

    if direction == Direction.LEFT:
        return top_left + Vector2(-vp_size.x / 2, vp_size.y / 2)
    elif direction == Direction.RIGHT:
        return top_left + Vector2(vp_size.x + vp_size.x / 2, vp_size.y / 2)
    elif direction == Direction.UP:
        return top_left + Vector2(vp_size.x / 2, -vp_size.y / 2)
    else:
        return top_left + Vector2(vp_size.x / 2, vp_size.y + vp_size.y / 2)
