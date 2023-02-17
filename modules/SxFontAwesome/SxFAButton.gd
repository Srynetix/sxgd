# FontAwesome button, displaying an icon.
tool
extends Button
class_name SxFaButton

# Icon name
export var icon_name := "anchor" setget _set_icon_name
# Icon size
export var icon_size := 24 setget _set_icon_size
# Icon color
export var icon_color := Color.white setget _set_icon_color
# Icon rotation
export var icon_rotation := 0.0 setget _set_icon_rotation

var _label: SxFaLabel

func _init() -> void:
    if !rect_min_size:
        rect_min_size = Vector2(64, 64)
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

func _update_label():
    if !_label:
        yield(self, "ready")

    _label.icon_name = icon_name
    _label.icon_size = icon_size
    _label.icon_color = icon_color
    _label.rect_pivot_offset = _label.rect_size / 2
    _label.rect_rotation = icon_rotation
