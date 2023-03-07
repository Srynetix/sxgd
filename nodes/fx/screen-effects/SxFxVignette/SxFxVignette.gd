# A vignette effect.
tool
extends ColorRect
class_name SxFxVignette

const SHADER = preload("res://addons/sxgd/nodes/fx/screen-effects/SxFxVignette/SxFxVignette.gdshader")

# Vignette size.
export var vignette_size := 10.0 setget _set_vignette_size
# Vignette ratio.
export var vignette_ratio := 0.25 setget _set_vignette_ratio

var _tween: Tween

func _set_vignette_ratio(value: float) -> void:
    vignette_ratio = value

    if !Engine.editor_hint:
        if material == null:
            yield(self, "ready")

        SxShader.set_shader_param(self, "ratio", value)

func _set_vignette_size(value: float) -> void:
    vignette_size = value

    if !Engine.editor_hint:
        if material == null:
            yield(self, "ready")

        SxShader.set_shader_param(self, "size", value)

func fade(duration: float = 1) -> void:
    _tween.stop_all()
    _tween.interpolate_property(self, "vignette_ratio", vignette_ratio, 1, duration)
    _tween.start()
    yield(_tween, "tween_all_completed")

func _ready() -> void:
    set_anchors_and_margins_preset(Control.PRESET_WIDE)
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    color = Color.transparent

    if !Engine.editor_hint:
        _tween = Tween.new()
        add_child(_tween)

        var shader_material := ShaderMaterial.new()
        shader_material.shader = SHADER
        material = shader_material

        _set_vignette_ratio(vignette_ratio)
        _set_vignette_size(vignette_size)

func _exit_tree():
    if !Engine.editor_hint:
        _tween.stop_all()
