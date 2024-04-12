@tool
extends Control
class_name SxFxVignette
## A ready-to-use vignette effect.

const _SHADER := preload("res://addons/sxgd/nodes/fx/screen-effects/SxFxVignette/SxFxVignette.gdshader")

## Vignette size.
@export var vignette_size := 10.0 : set = _set_vignette_size
## Vignette ratio.
@export var vignette_ratio := 0.25 : set = _set_vignette_ratio

var _rect: ColorRect
var _tween: Tween

## Show a fade effect.
func fade(duration: float = 1) -> void:
    if _tween:
        _tween.kill()
    _tween = get_tree().create_tween()

    _tween.tween_property(self, "vignette_ratio", 1.0, duration).from(vignette_ratio)
    await _tween.finished

func _set_vignette_ratio(value: float) -> void:
    vignette_ratio = value

    if !_rect:
        await self.ready

    SxShader.set_shader_parameter(_rect, "ratio", value)

func _set_vignette_size(value: float) -> void:
    vignette_size = value

    if !_rect:
        await self.ready

    SxShader.set_shader_parameter(_rect, "size", value)

func _ready() -> void:
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    mouse_filter = Control.MOUSE_FILTER_IGNORE

    var shader_material := ShaderMaterial.new()
    shader_material.shader = _SHADER

    _rect = ColorRect.new()
    _rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    _rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
    _rect.material = shader_material
    add_child(_rect)

    _set_vignette_ratio(vignette_ratio)
    _set_vignette_size(vignette_size)

func _exit_tree():
    if _tween:
        _tween.kill()
