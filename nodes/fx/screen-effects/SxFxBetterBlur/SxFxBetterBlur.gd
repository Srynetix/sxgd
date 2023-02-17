# A ready-to-use gaussian blur, compatible with GLES2.
extends Control
class_name SxFxBetterBlur

const SHADER_X = preload("res://addons/sxgd/nodes/fx/screen-effects/SxFxBetterBlur/SxFxBetterBlurX.gdshader")
const SHADER_Y = preload("res://addons/sxgd/nodes/fx/screen-effects/SxFxBetterBlur/SxFxBetterBlurY.gdshader")

export var strength := 0.0 setget _set_strength

var _step1: ColorRect
var _step2: ColorRect
var _copy: BackBufferCopy

func _set_strength(value: float) -> void:
    strength = value

    if !_step1:
        yield(self, "ready")

    SxShader.set_shader_param(_step1, "strength", value)
    SxShader.set_shader_param(_step2, "strength", value)

func _ready():
    var material_x := ShaderMaterial.new()
    material_x.shader = SHADER_X
    var material_y := ShaderMaterial.new()
    material_y.shader = SHADER_Y

    set_anchors_and_margins_preset(Control.PRESET_WIDE)
    mouse_filter = Control.MOUSE_FILTER_IGNORE

    _step1 = ColorRect.new()
    _step1.set_anchors_and_margins_preset(Control.PRESET_WIDE)
    _step1.mouse_filter = Control.MOUSE_FILTER_IGNORE
    _step1.material = material_x
    add_child(_step1)

    _copy = BackBufferCopy.new()
    _copy.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT
    add_child(_copy)

    _step2 = ColorRect.new()
    _step2.set_anchors_and_margins_preset(Control.PRESET_WIDE)
    _step2.mouse_filter = Control.MOUSE_FILTER_IGNORE
    _step2.material = material_y
    _copy.add_child(_step2)

    _copy.rect = Rect2(rect_position, rect_size)
    _set_strength(strength)
