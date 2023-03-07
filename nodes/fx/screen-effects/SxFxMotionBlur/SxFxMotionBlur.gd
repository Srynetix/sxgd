# A ready-to-use motion blur.
extends ColorRect
class_name SxFxMotionBlur

const SHADER = preload("res://addons/sxgd/nodes/fx/screen-effects/SxFxMotionBlur/SxFxMotionBlur.gdshader")

# Rotation angle in degrees.
export var angle_degrees := 0.0 setget _set_angle_degrees
# Effect strength.
export var strength := 0.0 setget _set_strength

func _set_strength(value: float) -> void:
    if material == null:
        yield(self, "ready")
    strength = value
    SxShader.set_shader_param(self, "strength", value)

func _set_angle_degrees(value: float) -> void:
    if material == null:
        yield(self, "ready")

    angle_degrees = value
    SxShader.set_shader_param(self, "angle_degrees", value)

func _ready() -> void:
    var shader_material := ShaderMaterial.new()
    shader_material.shader = SHADER

    set_anchors_and_margins_preset(Control.PRESET_WIDE)
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    material = shader_material

    _set_strength(strength)
    _set_angle_degrees(angle_degrees)
