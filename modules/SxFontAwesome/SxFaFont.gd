# Font management wrapper around FontAwesome.
extends Reference
class_name SxFaFont

const FASolidFont: DynamicFontData = preload("res://addons/sxgd/modules/SxFontAwesome/assets/otfs/Font Awesome 6 Free-Solid-900.otf")
const FARegularFont: DynamicFontData = preload("res://addons/sxgd/modules/SxFontAwesome/assets/otfs/Font Awesome 6 Free-Regular-400.otf")

const SxFaJsonData = preload("res://addons/sxgd/modules/SxFontAwesome/SxFaJsonData.gd")

# Font family
enum Family {
    Solid,
    Regular
}

const _CACHED_DATA := {
    "definition": null
}

# Lazily create a FontAwesome font, using a specific font family and a size.
# If the font already exists, it will be returned.
# If not, it will be created.
static func create_fa_font(family: int, size: int) -> DynamicFont:
    var key := _build_key(family, size)
    if _CACHED_DATA.has(key):
        return _CACHED_DATA[key]

    var font := DynamicFont.new()
    font.font_data = _get_font_family(family)
    font.size = size
    return font

# Get the icon unicode from its string representation.
static func get_icon_code(name: String) -> int:
    var definition := _get_definition()
    if definition.has(name):
        return ("0x%s" % definition[name]["unicode"]).hex_to_int()
    return -1

static func _build_key(family: int, size: int) -> String:
    return "%d-%d" % [family, size]

static func _get_font_family(family: int) -> DynamicFontData:
    match family:
        Family.Solid:
            return FASolidFont
        _:
            return FARegularFont

static func _has_definition() -> bool:
    return _CACHED_DATA["definition"] != null

static func _get_definition() -> Dictionary:
    if !_has_definition():
        _CACHED_DATA["definition"] = _load_definition()
    return _CACHED_DATA["definition"]

static func _load_definition() -> Dictionary:
    return SxFaJsonData.DATA
    # var f := File.new()
    # f.open("res://addons/sxgd/modules/SxFontAwesome/assets/metadata/icons.json", File.READ)
    # var result := JSON.parse(f.get_as_text())
    # return result.result


