extends Camera2D
class_name SxFXCamera

export var max_shake_strength: float = 2
export var shake_ratio: float = 0

onready var tween: Tween = $Tween

func _process(delta) -> void:
    _update_shake()

func _update_shake() -> void:
    var coef = rand_range(-1, 1) * max_shake_strength * shake_ratio
    offset = Vector2(coef, coef)

# Tween to a specific position
#
# Example:
#   camera.tween_to_position(Vector2(100, 100))
func tween_to_position(position: Vector2, speed: float = 0.5, zoom: float = 1) -> void:
    tween.stop_all()
    tween.interpolate_property(self, "global_position", global_position, position, speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
    tween.interpolate_property(self, "zoom", self.zoom, Vector2.ONE * zoom, speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
    tween.start()

    yield(tween, "tween_all_completed")
