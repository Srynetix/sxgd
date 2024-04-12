@tool
extends Button
class_name SxFaButton
## FontAwesome button, displaying an icon.

## Icon name
@export var icon_name := "anchor" : set = _set_icon_name
## Icon size
@export var icon_size := 24 : set = _set_icon_size
## Icon color
@export var icon_color := Color.WHITE : set = _set_icon_color
## Icon rotation
@export var icon_rotation := 0.0 : set = _set_icon_rotation

var _label: SxFaLabel

func _init() -> void:
    if custom_minimum_size == Vector2.ZERO:
        custom_minimum_size = Vector2(64, 64)
    expand_icon = true

    _label = SxFaLabel.new()
    add_child(_label)

func _ready() -> void:
    _set_icon_name(icon_name)
    _set_icon_size(icon_size)
    _set_icon_color(icon_color)
    _set_icon_rotation(icon_rotation)

func _set_icon_name(value: String) -> void:
    icon_name = value
    _update_label()

func _set_icon_size(value: int) -> void:
    icon_size = value
    _update_label()

func _set_icon_color(value: Color) -> void:
    icon_color = value
    _update_label()

func _set_icon_rotation(value: float) -> void:
    icon_rotation = value
    _update_label()

func _update_label() -> void:
    if !_label:
        await self.ready

    _label.icon_name = icon_name
    _label.icon_size = icon_size
    _label.icon_color = icon_color
    _label.pivot_offset = _label.size / 2
    _label.rotation_degrees = icon_rotation
