# A ready-to-use gaussian blur, compatible with GLES2.
#
# <p align="center">
#   <img src="../../../../images/nodes/SxBetterBlur.gif" alt="preview" />
# </p>
tool
extends Control
class_name SxBetterBlur

export var strength := 0.0 setget set_strength

onready var step1 := $Step1 as ColorRect
onready var step2 := $BackBufferCopy/Step2 as ColorRect
onready var copy := $BackBufferCopy as BackBufferCopy

func set_strength(value: float) -> void:
    strength = value

    if !step1:
        yield(self, "ready")

    SxShader.set_shader_param(step1, "strength", value)
    SxShader.set_shader_param(step2, "strength", value)

func _ready():
    copy.rect = Rect2(rect_position, rect_size)
    set_strength(strength)
