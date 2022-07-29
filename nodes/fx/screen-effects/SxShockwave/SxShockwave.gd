# An animated shockwave effect.
#
# <p align="center">
#     <img src="../../../../images/nodes/SxShockwave.gif" alt="preview" />
# </p>
tool
extends ColorRect
class_name SxShockwave

export var wave_size := 0.0 setget set_wave_size
export var wave_center := Vector2.ZERO setget set_wave_center
export var force := 0.0 setget set_force
export var thickness := 0.0 setget set_thickness

onready var tween := $Tween as Tween

func set_wave_size(value: float) -> void:
    wave_size = value
    SxShader.set_shader_param(self, "size", value)

func set_wave_center(value: Vector2) -> void:
    wave_center = value
    SxShader.set_shader_param(self, "center", value)

func set_force(value: float) -> void:
    force = value
    SxShader.set_shader_param(self, "force", value)

func set_thickness(value: float) -> void:
    thickness = value
    SxShader.set_shader_param(self, "thickness", value)

func start_wave(position: Vector2) -> void:
    set_wave_center(position)

    tween.stop_all()
    tween.interpolate_property(material, "shader_param/size", 0.1, 1.25, 2)
    tween.interpolate_property(material, "shader_param/force", 0, 0.25, 2)
    tween.interpolate_property(material, "shader_param/thickness", 0, 0.1, 2)
    tween.start()

func wave_is_running() -> bool:
    return tween.is_active()

func _exit_tree():
    tween.stop_all()
