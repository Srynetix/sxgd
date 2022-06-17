# FontAwesome label, used to easily display a FontAwesome icon.
tool
extends Label
class_name SxFALabel

# Icon name
export var icon_name: String = "anchor" setget _set_icon_name
# Icon size
export var icon_size: int = 24 setget _set_icon_size
# Icon color
export var icon_color: Color = Color.white setget _set_icon_color

func _enter_tree():
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

func _update_font():
    var fa_font = SxFAFont.create_fa_font(SxFAFont.Family.Solid, icon_size)
    set("custom_fonts/font", fa_font)
    var code = SxFAFont.get_icon_code(icon_name)
    if code != -1:
        text = char(code)

func _update_color():
    set("custom_colors/font_color", icon_color)
