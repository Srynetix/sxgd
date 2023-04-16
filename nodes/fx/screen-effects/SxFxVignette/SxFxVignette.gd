# A vignette effect.
@tool
extends ColorRect
class_name SxFxVignette

const shader := preload("res://addons/sxgd/nodes/fx/screen-effects/SxFxVignette/SxFxVignette.gdshader")

# Vignette size.
@export var vignette_size := 10.0 : set = _set_vignette_size
# Vignette ratio.
@export var vignette_ratio := 0.25 : set = _set_vignette_ratio

var _tween: Tween

func _set_vignette_ratio(value: float) -> void:
    vignette_ratio = value

    if !Engine.is_editor_hint():
        if material == null:
            await self.ready

        SxShader.set_shader_parameter(self, "ratio", value)

func _set_vignette_size(value: float) -> void:
    vignette_size = value

    if !Engine.is_editor_hint():
        if material == null:
            await self.ready

        SxShader.set_shader_parameter(self, "size", value)

func fade(duration: float = 1) -> void:
    if _tween:
        _tween.kill()
    _tween = get_tree().create_tween()

    _tween.tween_property(self, "vignette_ratio", 1.0, duration).from(vignette_ratio)
    await _tween.finished

func _ready() -> void:
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    color = Color.TRANSPARENT

    if !Engine.is_editor_hint():
        var shader_material := ShaderMaterial.new()
        shader_material.shader = shader
        material = shader_material

        _set_vignette_ratio(vignette_ratio)
        _set_vignette_size(vignette_size)

func _exit_tree():
    if !Engine.is_editor_hint():
        if _tween:
            _tween.kill()
