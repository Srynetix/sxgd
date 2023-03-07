# FontAwesome label, used to easily display a FontAwesome icon.
tool
extends Label
class_name SxFaLabel

# Icon name
export var icon_name := "anchor" setget _set_icon_name
# Icon size
export var icon_size := 24 setget _set_icon_size
# Icon color
export var icon_color := Color.white setget _set_icon_color

func _init() -> void:
    set_anchors_and_margins_preset(Control.PRESET_WIDE)
    align = Label.ALIGN_CENTER
    valign = Label.VALIGN_CENTER

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

func _update_font():
    var fa_font := SxFaFont.create_fa_font(SxFaFont.Family.Solid, icon_size)
    set("custom_fonts/font", fa_font)
    var code := SxFaFont.get_icon_code(icon_name)
    if code != -1:
        text = char(code)

func _update_color():
    set("custom_colors/font_color", icon_color)
