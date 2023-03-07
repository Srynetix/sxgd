extends ColorRect
class_name SxFxChromaticAberration

const SHADER = preload("res://addons/sxgd/nodes/fx/screen-effects/SxFxChromaticAberration/SxFxChromaticAberration.gdshader")

export var enabled := true setget _set_enabled
export var amount := 1.0 setget _set_amount

func _ready() -> void:
    var shader_material := ShaderMaterial.new()
    shader_material.shader = SHADER

    set_anchors_and_margins_preset(Control.PRESET_WIDE)
    material = shader_material

    _set_enabled(enabled)
    _set_amount(amount)

func _set_enabled(value: bool) -> void:
    if material == null:
        yield(self, "ready")

    enabled = value
    _get_material().set_shader_param("apply", value)

func _set_amount(value: float) -> void:
    if material == null:
        yield(self, "ready")

    amount = value
    _get_material().set_shader_param("amount", value)

func _get_material() -> ShaderMaterial:
    return material as ShaderMaterial
