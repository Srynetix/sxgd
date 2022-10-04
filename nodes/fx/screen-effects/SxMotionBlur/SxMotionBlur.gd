# A ready-to-use motion blur.
#
# <p align="center">
#     <img src="../../../../images/nodes/SxMotionBlur.gif" alt="preview" />
# </p>
tool
extends ColorRect
class_name SxMotionBlur

# Rotation angle in degrees.
export var angle_degrees := 0.0 setget set_angle_degrees
# Effect strength.
export var strength := 0.0 setget set_strength

func set_strength(value: float) -> void:
    strength = value
    SxShader.set_shader_param(self, "strength", value)

func set_angle_degrees(value: float) -> void:
    angle_degrees = value
    SxShader.set_shader_param(self, "angle_degrees", value)

func _ready() -> void:
    set_strength(strength)
    set_angle_degrees(angle_degrees)
