# FontAwesome button, displaying an icon.
tool
extends Button
class_name SxFAButton

# Icon name
export var icon_name: String = "anchor" setget _set_icon_name
# Icon size
export var icon_size: int = 24 setget _set_icon_size
# Icon color
export var icon_color: Color = Color.white setget _set_icon_color

onready var _label: SxFALabel = $SxFALabel

func _ready():
    _update_label()

func _set_icon_name(value: String) -> void:
    icon_name = value
    _update_label()

func _set_icon_size(value: int) -> void:
    icon_size = value
    _update_label()

func _set_icon_color(value: Color) -> void:
    icon_color = value
    _update_label()

func _update_label():
    if !_label:
        yield(self, "ready")

    _label.icon_name = icon_name
    _label.icon_size = icon_size
    _label.icon_color = icon_color
