# An animated shockwave effect.
tool
extends ColorRect
class_name SxFxShockwave

const SHADER = preload("res://addons/sxgd/nodes/fx/screen-effects/SxFxShockwave/SxFxShockwave.gdshader")

export var wave_size := 0.0 setget _set_wave_size
export var wave_center := Vector2.ZERO setget _set_wave_center
export var force := 0.0 setget _set_force
export var thickness := 0.0 setget _set_thickness

var _tween: Tween

func _set_wave_size(value: float) -> void:
    wave_size = value

    if !Engine.editor_hint:
        if material == null:
            yield(self, "ready")

        SxShader.set_shader_param(self, "size", value)

func _set_wave_center(value: Vector2) -> void:
    wave_center = value

    if !Engine.editor_hint:
        if material == null:
            yield(self, "ready")

        SxShader.set_shader_param(self, "center", value)

func _set_force(value: float) -> void:
    force = value

    if !Engine.editor_hint:
        if material == null:
            yield(self, "ready")

        SxShader.set_shader_param(self, "force", value)

func _set_thickness(value: float) -> void:
    thickness = value

    if !Engine.editor_hint:
        if material == null:
            yield(self, "ready")

        SxShader.set_shader_param(self, "thickness", value)

func start_wave(position: Vector2) -> void:
    _set_wave_center(position)

    _tween.stop_all()
    _tween.interpolate_property(material, "shader_param/size", 0.1, 1.25, 2)
    _tween.interpolate_property(material, "shader_param/force", 0, 0.25, 2)
    _tween.interpolate_property(material, "shader_param/thickness", 0, 0.1, 2)
    _tween.start()

func wave_is_running() -> bool:
    return _tween.is_active()

func _ready() -> void:
    set_anchors_and_margins_preset(Control.PRESET_WIDE)
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    color = Color.transparent

    if !Engine.editor_hint:
        _tween = Tween.new()
        add_child(_tween)

        var shader_material := ShaderMaterial.new()
        shader_material.shader = SHADER
        material = shader_material

        _set_wave_size(wave_size)
        _set_thickness(thickness)
        _set_force(force)
        _set_wave_center(wave_center)

func _exit_tree():
    if !Engine.editor_hint:
        _tween.stop_all()
