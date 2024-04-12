@tool
extends ColorRect
class_name SxFxGrayscale
## A ready-to-use grayscale effect.

const _SHADER := preload("res://addons/sxgd/nodes/fx/screen-effects/SxFxGrayscale/SxFxGrayscale.gdshader")

## Effect ratio.
@export var ratio := 0.0 : set = _set_ratio

func _set_ratio(value: float) -> void:
    ratio = clamp(value, 0, 1)

    if !Engine.is_editor_hint():
        if material == null:
            await self.ready
        _get_material().set_shader_parameter("ratio", ratio)

func _get_material() -> ShaderMaterial:
    return material as ShaderMaterial

func _ready() -> void:
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    color = Color.TRANSPARENT

    if !Engine.is_editor_hint():
        var shader_material := ShaderMaterial.new()
        shader_material.shader = _SHADER
        material = shader_material

        _set_ratio(ratio)
