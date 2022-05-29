tool
extends ColorRect
class_name SxMotionBlur

export var angle_degrees: float = 0 setget set_angle_degrees
export var strength: float = 0 setget set_strength

func set_strength(value: float) -> void:
    strength = value
    SxShader.set_shader_param(self, "strength", value)

func set_angle_degrees(value: float) -> void:
    angle_degrees = value
    SxShader.set_shader_param(self, "angle_degrees", value)
