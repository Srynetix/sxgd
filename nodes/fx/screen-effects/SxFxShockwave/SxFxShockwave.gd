# An animated shockwave effect.
@tool
extends ColorRect
class_name SxFxShockwave

const shader := preload("res://addons/sxgd/nodes/fx/screen-effects/SxFxShockwave/SxFxShockwave.gdshader")

@export var wave_size := 0.0 : set = _set_wave_size
@export var wave_center := Vector2.ZERO : set = _set_wave_center
@export var force := 0.0 : set = _set_force
@export var thickness := 0.0 : set = _set_thickness
@export var wave_on_startup := false

var _tween: Tween

func _set_wave_size(value: float) -> void:
    wave_size = value

    if !Engine.is_editor_hint():
        if material == null:
            await self.ready

        SxShader.set_shader_parameter(self, "size", value)

func _set_wave_center(value: Vector2) -> void:
    wave_center = value

    if !Engine.is_editor_hint():
        if material == null:
            await self.ready

        SxShader.set_shader_parameter(self, "center", value)

func _set_force(value: float) -> void:
    force = value

    if !Engine.is_editor_hint():
        if material == null:
            await self.ready

        SxShader.set_shader_parameter(self, "force", value)

func _set_thickness(value: float) -> void:
    thickness = value

    if !Engine.is_editor_hint():
        if material == null:
            await self.ready

        SxShader.set_shader_parameter(self, "thickness", value)

func start_wave(position: Vector2) -> void:
    _set_wave_center(position)

    if _tween:
        _tween.kill()
    _tween = get_tree().create_tween()

    _tween.tween_property(material, "shader_parameter/size", 1.25, 2).from(0.1)
    _tween.tween_property(material, "shader_parameter/force", 0.25, 2).from(0.0)
    _tween.tween_property(material, "shader_parameter/thickness", 0.1, 2).from(0.0)

func wave_is_running() -> bool:
    return _tween && _tween.is_running()

func _ready() -> void:
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    color = Color.TRANSPARENT

    if !Engine.is_editor_hint():
        var shader_material := ShaderMaterial.new()
        shader_material.shader = shader
        material = shader_material

        _set_wave_size(wave_size)
        _set_thickness(thickness)
        _set_force(force)
        _set_wave_center(wave_center)

        if wave_on_startup:
            start_wave(get_viewport_rect().size / 2)

func _exit_tree():
    if !Engine.is_editor_hint():
        if _tween:
            _tween.kill()
