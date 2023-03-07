tool
extends ColorRect
class_name SxFxChromaticAberration

const SHADER = preload("res://addons/sxgd/nodes/fx/screen-effects/SxFxChromaticAberration/SxFxChromaticAberration.gdshader")

export var enabled := true setget _set_enabled
export var amount := 1.0 setget _set_amount

func _ready() -> void:
    set_anchors_and_margins_preset(Control.PRESET_WIDE)
    color = Color.transparent

    if !Engine.editor_hint:
        var shader_material := ShaderMaterial.new()
        shader_material.shader = SHADER
        material = shader_material

        _set_enabled(enabled)
        _set_amount(amount)

func _set_enabled(value: bool) -> void:
    enabled = value

    if !Engine.editor_hint:
        if material == null:
            yield(self, "ready")
        _get_material().set_shader_param("apply", value)

func _set_amount(value: float) -> void:
    amount = value

    if !Engine.editor_hint:
        if material == null:
            yield(self, "ready")
        _get_material().set_shader_param("amount", value)

func _get_material() -> ShaderMaterial:
    return material as ShaderMaterial
