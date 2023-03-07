# A ready-to-use motion blur.
tool
extends ColorRect
class_name SxFxMotionBlur

const SHADER = preload("res://addons/sxgd/nodes/fx/screen-effects/SxFxMotionBlur/SxFxMotionBlur.gdshader")

# Rotation angle in degrees.
export var angle_degrees := 0.0 setget _set_angle_degrees
# Effect strength.
export var strength := 0.0 setget _set_strength

func _set_strength(value: float) -> void:
    strength = value

    if !Engine.editor_hint:
        if material == null:
            yield(self, "ready")
        SxShader.set_shader_param(self, "strength", value)

func _set_angle_degrees(value: float) -> void:
    angle_degrees = value

    if !Engine.editor_hint:
        if material == null:
            yield(self, "ready")
        SxShader.set_shader_param(self, "angle_degrees", value)

func _ready() -> void:
    set_anchors_and_margins_preset(Control.PRESET_WIDE)
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    color = Color.transparent

    if !Engine.editor_hint:
        var shader_material := ShaderMaterial.new()
        shader_material.shader = SHADER
        material = shader_material

        _set_strength(strength)
        _set_angle_degrees(angle_degrees)
