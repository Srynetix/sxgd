extends ColorRect
class_name SxFxGrayscale

const SHADER = preload("res://addons/sxgd/nodes/fx/screen-effects/SxFxGrayscale/SxFxGrayscale.gdshader")

export var ratio := 0.0 setget _set_ratio

func _set_ratio(value: float) -> void:
    if material == null:
        yield(self, "ready")

    ratio = clamp(value, 0, 1)
    _get_material().set_shader_param("ratio", ratio)

func _get_material() -> ShaderMaterial:
    return material as ShaderMaterial

func _ready() -> void:
    var shader_material := ShaderMaterial.new()
    shader_material.shader = SHADER

    set_anchors_and_margins_preset(Control.PRESET_WIDE)
    material = shader_material

    _set_ratio(ratio)
