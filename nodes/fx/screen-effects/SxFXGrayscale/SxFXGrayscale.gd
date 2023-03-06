tool
extends ColorRect
class_name SxFXGrayscale

export var ratio := 0.0 setget _set_ratio

func _set_ratio(value: float) -> void:
    ratio = clamp(value, 0, 1)
    _get_material().set_shader_param("ratio", ratio)

func _get_material() -> ShaderMaterial:
    if material == null:
        yield(self, "ready")

    return material as ShaderMaterial

func _ready() -> void:
    _set_ratio(ratio)
