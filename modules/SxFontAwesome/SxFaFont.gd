@tool
extends Object
class_name SxFaFont
## Font management wrapper around FontAwesome.

static var _fonts: Dictionary = {}
static var _definition: Dictionary = {}

const FASolidFont := preload("res://addons/sxgd/modules/SxFontAwesome/assets/otfs/Font Awesome 6 Free-Solid-900.otf")
const FARegularFont := preload("res://addons/sxgd/modules/SxFontAwesome/assets/otfs/Font Awesome 6 Free-Regular-400.otf")
const SxFaJsonData = preload("res://addons/sxgd/modules/SxFontAwesome/SxFaJsonData.gd")

## Font family.
enum Family {
    ## Solid.
    Solid,
    ## Regular.
    Regular
}

## Lazily create a FontAwesome font, using a specific font family and a size.[br]
## If the font already exists, it will be returned.[br]
## If not, it will be created.
static func create_fa_font(family: int) -> Font:
    if _fonts.has(family):
        return _fonts[family]

    return _get_font_family(family)

## Get the icon unicode from its string representation.
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
    return _definition != {}

static func _get_definition() -> Dictionary:
    if !_has_definition():
        _definition = _load_definition()
    return _definition

static func _load_definition() -> Dictionary:
    return SxFaJsonData.DATA


