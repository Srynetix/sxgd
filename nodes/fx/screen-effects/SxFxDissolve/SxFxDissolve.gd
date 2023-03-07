tool
extends ColorRect
class_name SxFxDissolve

const SHADER = preload("res://addons/sxgd/nodes/fx/screen-effects/SxFxDissolve/SxFxDissolve.gdshader")

export var noise_period := 64.0 setget _set_noise_period
export var replacement_color := Color(1, 1, 1, 0) setget _set_replacement_color
export var ratio := 0.0 setget _set_ratio

func _set_ratio(value: float) -> void:
    ratio = clamp(value, 0, 1)

    if !Engine.editor_hint:
        if material == null:
            yield(self, "ready")
        _get_material().set_shader_param("dissolution_level", ratio)

func _set_replacement_color(value: Color) -> void:
    replacement_color = value

    if !Engine.editor_hint:
        if material == null:
            yield(self, "ready")
        _get_material().set_shader_param("replacement_color", value)

func _set_noise_period(value: float) -> void:
    noise_period = value

    if !Engine.editor_hint:
        if material == null:
            yield(self, "ready")

        var noise_tex := _get_material().get_shader_param("noise") as NoiseTexture
        noise_tex.noise.period = noise_period
        _get_material().set_shader_param("noise", noise_tex)

func _get_material() -> ShaderMaterial:
    return material as ShaderMaterial

func _ready() -> void:
    set_anchors_and_margins_preset(Control.PRESET_WIDE)
    color = Color.transparent

    if !Engine.editor_hint:
        var noise := OpenSimplexNoise.new()
        var noise_texture := NoiseTexture.new()
        noise_texture.noise = noise

        var shader_material := ShaderMaterial.new()
        shader_material.shader = SHADER
        shader_material.set_shader_param("noise", noise_texture)
        shader_material.set_shader_param("edge_width", 0.0)
        shader_material.set_shader_param("edge_color1", Color.black)
        shader_material.set_shader_param("edge_color2", Color.black)
        material = shader_material

        _set_ratio(ratio)
        _set_replacement_color(replacement_color)
        _set_noise_period(noise_period)
