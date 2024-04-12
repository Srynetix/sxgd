@tool
extends ColorRect
class_name SxFxChromaticAberration
## A ready-to-use chromatic aberration effect.

const _SHADER := preload("res://addons/sxgd/nodes/fx/screen-effects/SxFxChromaticAberration/SxFxChromaticAberration.gdshader")

## Enable the effect.
@export var enabled := true : set = _set_enabled
## Effect amount.
@export var amount := 1.0 : set = _set_amount

func _ready() -> void:
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    color = Color.TRANSPARENT

    if !Engine.is_editor_hint():
        var shader_material := ShaderMaterial.new()
        shader_material.shader = _SHADER
        material = shader_material

        _set_enabled(enabled)
        _set_amount(amount)

func _set_enabled(value: bool) -> void:
    enabled = value

    if !Engine.is_editor_hint():
        if material == null:
            await self.ready
        _get_material().set_shader_parameter("apply", value)

func _set_amount(value: float) -> void:
    amount = value

    if !Engine.is_editor_hint():
        if material == null:
            await self.ready
        _get_material().set_shader_parameter("amount", value)

func _get_material() -> ShaderMaterial:
    return material as ShaderMaterial
