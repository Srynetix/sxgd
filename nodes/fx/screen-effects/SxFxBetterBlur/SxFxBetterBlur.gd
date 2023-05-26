# A ready-to-use gaussian blur, compatible with GLES2.
@tool
extends Control
class_name SxFxBetterBlur

const shader_x := preload("res://addons/sxgd/nodes/fx/screen-effects/SxFxBetterBlur/SxFxBetterBlurX.gdshader")
const shader_y := preload("res://addons/sxgd/nodes/fx/screen-effects/SxFxBetterBlur/SxFxBetterBlurY.gdshader")

@export var strength := 0.0 : set = _set_strength

var _step1: ColorRect
var _step2: ColorRect
var _copy: BackBufferCopy

func _set_strength(value: float) -> void:
    strength = value

    if !_step1:
        await self.ready

    SxShader.set_shader_parameter(_step1, "strength", value)
    SxShader.set_shader_parameter(_step2, "strength", value)

func _ready() -> void:
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    mouse_filter = Control.MOUSE_FILTER_IGNORE

    var material_x := ShaderMaterial.new()
    material_x.shader = shader_x
    var material_y := ShaderMaterial.new()
    material_y.shader = shader_y

    _step1 = ColorRect.new()
    _step1.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    _step1.mouse_filter = Control.MOUSE_FILTER_IGNORE
    _step1.material = material_x
    add_child(_step1)

    _copy = BackBufferCopy.new()
    _copy.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT
    add_child(_copy)

    _step2 = ColorRect.new()
    _step2.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    _step2.mouse_filter = Control.MOUSE_FILTER_IGNORE
    _step2.material = material_y
    _copy.add_child(_step2)

    _copy.rect = Rect2(position, size)
    _set_strength(strength)
