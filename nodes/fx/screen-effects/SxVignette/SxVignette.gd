# A vignette effect.
#
# <p align="center">
#     <img src="../../../../images/nodes/SxVignette.gif" alt="preview" />
# </p>
tool
extends ColorRect
class_name SxVignette

# Vignette size.
export var vignette_size: float = 10 setget set_vignette_size
# Vignette ratio.
export var vignette_ratio: float = 0.25 setget set_vignette_ratio

onready var tween: Tween = $Tween

func set_vignette_ratio(value: float) -> void:
    vignette_ratio = value
    SxShader.set_shader_param(self, "ratio", value)

func set_vignette_size(value: float) -> void:
    vignette_size = value
    SxShader.set_shader_param(self, "size", value)

func fade(duration: float = 1) -> void:
    tween.stop_all()
    tween.interpolate_property(self, "vignette_ratio", vignette_ratio, 1, duration)
    tween.start()

    yield(tween, "tween_all_completed")

func _exit_tree():
    tween.stop_all()
