# FontAwesome label, used to easily display a FontAwesome icon.
@tool
extends Label
class_name SxFaLabel

# Icon name
@export var icon_name := "anchor" : set = _set_icon_name
# Icon size
@export var icon_size := 24 : set = _set_icon_size
# Icon color
@export var icon_color := Color.WHITE : set = _set_icon_color

func _init() -> void:
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    vertical_alignment = VERTICAL_ALIGNMENT_CENTER

func _ready() -> void:
    _update_font()
    _update_color()

func _set_icon_name(value: String) -> void:
    icon_name = value
    _update_font()

func _set_icon_size(value: int) -> void:
    icon_size = value
    _update_font()

func _set_icon_color(value: Color) -> void:
    icon_color = value
    _update_color()

func _update_font() -> void:
    var fa_font := SxFaFont.create_fa_font(SxFaFont.Family.Solid)
    add_theme_font_override("font", fa_font)
    add_theme_font_size_override("font_size", icon_size)
    var code := SxFaFont.get_icon_code(icon_name)
    if code != -1:
        text = char(code)

func _update_color() -> void:
    add_theme_color_override("font_color", icon_color)
