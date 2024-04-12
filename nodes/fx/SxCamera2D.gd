extends Camera2D
class_name SxCamera2D
## Augmented [Camera2D].

## Camera direction.
enum Direction {
    ## Left.
    LEFT = 0,
    ## Right.
    RIGHT,
    ## Up.
    UP,
    ## Down.
    DOWN
}

## Max shake strength.
@export var max_shake_strength := 2.0
## Shake ratio.
@export var shake_ratio := 0.0

var _tween: Tween

## Tween to a specific position.[br]
##
## Usage:
## [codeblock]
## camera.tween_to_position(Vector2(100, 100))
## [/codeblock]
func tween_to_position(position: Vector2, speed: float = 0.5, zoom_: float = 1, easing: int = Tween.TRANS_QUAD) -> void:
    if _tween:
        _tween.kill()
    _tween = get_tree().create_tween()

    _tween.tween_property(self, "global_position", position, speed).from(global_position).set_trans(easing).set_ease(Tween.EASE_IN_OUT)
    _tween.tween_property(self, "zoom", Vector2.ONE * zoom, speed).from(zoom).set_trans(easing).set_ease(Tween.EASE_IN_OUT)

    await _tween.finished

## Apply a viewport scroll effect.[br]
##
## Usage:
## [codeblock]
## camera.viewport_scroll(Vector2(0, 0), Direction.RIGHT)
## [/codeblock]
func viewport_scroll(top_left: Vector2, direction: int, speed: float = 0.65, easing: int = Tween.TRANS_QUAD) -> void:
    var vp_size := get_viewport_rect().size

    reset_limits()
    var start_position := top_left + vp_size / 2
    var end_position := _add_viewport_size_to_position(top_left, direction)
    global_position = start_position

    if _tween:
        _tween.kill()
    _tween = get_tree().create_tween()
    _tween.tween_property(self, "global_position", end_position, speed).from(start_position).set_trans(easing).set_ease(Tween.EASE_IN_OUT)
    await _tween.finished

    limit_left = end_position.x - vp_size.x / 2
    limit_right = limit_left + vp_size.x
    limit_top = end_position.y - vp_size.y / 2
    limit_bottom = limit_top + vp_size.y
    position_smoothing_enabled = true

## Reset the camera limits to an arbitrary large number.
func reset_limits() -> void:
    limit_left = -1000000
    limit_right = 1000000
    limit_top = -1000000
    limit_bottom = 1000000
    position_smoothing_enabled = false

## Set the camera limits using a [Rect2].
func set_limit_from_rect(rect: Rect2) -> void:
    limit_left = rect.position.x
    limit_right = rect.end.x
    limit_top = rect.position.y
    limit_bottom = rect.end.y

func _process(delta) -> void:
    _update_shake()

func _update_shake() -> void:
    var coef := randf_range(-1, 1) * max_shake_strength * shake_ratio
    offset = Vector2(coef, coef)

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
