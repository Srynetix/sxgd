@tool
extends ColorRect
class_name SxFxDissolve

const shader := preload("res://addons/sxgd/nodes/fx/screen-effects/SxFxDissolve/SxFxDissolve.gdshader")

@export var noise_frequency := 0.01 : set = _set_noise_frequency
@export var replacement_color := Color(1, 1, 1, 0) : set = _set_replacement_color
@export var ratio := 0.0 : set = _set_ratio

func _set_ratio(value: float) -> void:
    ratio = clamp(value, 0, 1)

    if !Engine.is_editor_hint():
        if material == null:
            await self.ready
        _get_material().set_shader_parameter("dissolution_level", ratio)

func _set_replacement_color(value: Color) -> void:
    replacement_color = value

    if !Engine.is_editor_hint():
        if material == null:
            await self.ready
        _get_material().set_shader_parameter("replacement_color", value)

func _set_noise_frequency(value: float) -> void:
    noise_frequency = value

    if !Engine.is_editor_hint():
        if material == null:
            await self.ready

        var noise_tex := _get_material().get_shader_parameter("noise") as NoiseTexture2D
        noise_tex.noise.frequency = noise_frequency
        _get_material().set_shader_parameter("noise", noise_tex)

func _get_material() -> ShaderMaterial:
    return material as ShaderMaterial

func _ready() -> void:
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    color = Color.TRANSPARENT

    if !Engine.is_editor_hint():
        var noise := FastNoiseLite.new()
        var noise_texture := NoiseTexture2D.new()
        noise_texture.noise = noise

        var shader_material := ShaderMaterial.new()
        shader_material.shader = shader
        shader_material.set_shader_parameter("noise", noise_texture)
        shader_material.set_shader_parameter("edge_width", 0.0)
        shader_material.set_shader_parameter("edge_color1", Color.BLACK)
        shader_material.set_shader_parameter("edge_color2", Color.BLACK)
        material = shader_material

        _set_ratio(ratio)
        _set_replacement_color(replacement_color)
        _set_noise_frequency(noise_frequency)
