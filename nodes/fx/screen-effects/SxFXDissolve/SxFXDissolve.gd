tool
extends ColorRect
class_name SxFXDissolve

export var noise_period := 64.0 setget _set_noise_period
export var replacement_color := Color(1, 1, 1, 0) setget _set_replacement_color
export var ratio := 0.0 setget _set_ratio

func _set_ratio(value: float) -> void:
    ratio = clamp(value, 0, 1)
    _get_material().set_shader_param("dissolution_level", ratio)

func _set_replacement_color(value: Color) -> void:
    replacement_color = value
    _get_material().set_shader_param("replacement_color", value)

func _set_noise_period(value: float) -> void:
    noise_period = value
    var noise_tex := _get_material().get_shader_param("noise") as NoiseTexture
    noise_tex.noise.period = noise_period
    _get_material().set_shader_param("noise", noise_tex)

func _get_material() -> ShaderMaterial:
    if material == null:
        yield(self, "_ready")

    return material as ShaderMaterial

func _ready() -> void:
    _set_ratio(ratio)
    _set_replacement_color(replacement_color)
    _set_noise_period(noise_period)
