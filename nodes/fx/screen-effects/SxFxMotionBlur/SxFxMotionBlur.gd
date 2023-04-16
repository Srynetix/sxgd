# A ready-to-use motion blur.
@tool
extends ColorRect
class_name SxFxMotionBlur

const shader := preload("res://addons/sxgd/nodes/fx/screen-effects/SxFxMotionBlur/SxFxMotionBlur.gdshader")

# Rotation angle in degrees.
@export var angle_degrees := 0.0 : set = _set_angle_degrees
# Effect strength.
@export var strength := 0.0 : set = _set_strength

func _set_strength(value: float) -> void:
    strength = value

    if !Engine.is_editor_hint():
        if material == null:
            await self.ready
        SxShader.set_shader_parameter(self, "strength", value)

func _set_angle_degrees(value: float) -> void:
    angle_degrees = value

    if !Engine.is_editor_hint():
        if material == null:
            await self.ready
        SxShader.set_shader_parameter(self, "angle_degrees", value)

func _ready() -> void:
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    color = Color.TRANSPARENT

    if !Engine.is_editor_hint():
        var shader_material := ShaderMaterial.new()
        shader_material.shader = shader
        material = shader_material

        _set_strength(strength)
        _set_angle_degrees(angle_degrees)
