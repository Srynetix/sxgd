# Font management wrapper around FontAwesome.
extends Object
class_name SxFaFont

const FASolidFont := preload("res://addons/sxgd/modules/SxFontAwesome/assets/otfs/Font Awesome 6 Free-Solid-900.otf")
const FARegularFont := preload("res://addons/sxgd/modules/SxFontAwesome/assets/otfs/Font Awesome 6 Free-Regular-400.otf")

const SxFaJsonData = preload("res://addons/sxgd/modules/SxFontAwesome/SxFaJsonData.gd")

# Font family
enum Family {
    Solid,
    Regular
}

# Lazily create a FontAwesome font, using a specific font family and a size.
# If the font already exists, it will be returned.
# If not, it will be created.
static func create_fa_font(family: int) -> Font:
    SxAttr.setup_static_attribute("SxFaFont", "fonts", {})

    var cached_data := SxAttr.get_static_attribute("SxFaFont", "fonts") as Dictionary
    if cached_data.has(family):
        return cached_data[family]

    return _get_font_family(family)

# Get the icon unicode from its string representation.
static func get_icon_code(name: String) -> int:
    var definition := _get_definition()
    if definition.has(name):
        return ("0x%s" % definition[name]["unicode"]).hex_to_int()
    return -1

static func _get_font_family(family: int) -> Font:
    match family:
        Family.Solid:
            return FASolidFont
        _:
            return FARegularFont

static func _has_definition() -> bool:
    return SxAttr.get_static_attribute("SxFaFont", "definition") != null

static func _get_definition() -> Dictionary:
    SxAttr.setup_static_attribute("SxFaFont", "definition", null)

    if !_has_definition():
        SxAttr.set_static_attribute("SxFaFont", "definition", _load_definition())
    return SxAttr.get_static_attribute("SxFaFont", "definition")

static func _load_definition() -> Dictionary:
    return SxFaJsonData.DATA


