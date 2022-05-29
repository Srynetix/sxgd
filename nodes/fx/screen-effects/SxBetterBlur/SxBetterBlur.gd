tool
extends Control
class_name SxBetterBlur

export var strength: float = 0 setget set_strength

onready var step1: ColorRect = $Step1
onready var step2: ColorRect = $BackBufferCopy/Step2
onready var copy: BackBufferCopy = $BackBufferCopy

func set_strength(value: float) -> void:
    strength = value

    if Engine.editor_hint:
        if step1 == null && step2 == null:
            _ready()

    if step1 != null && step2 != null:
        SxShader.set_shader_param(step1, "strength", value)
        SxShader.set_shader_param(step2, "strength", value)

func _ready():
    copy.rect = Rect2(rect_position, rect_size)
    set_strength(strength)
