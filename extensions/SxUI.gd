extends Reference
class_name SxUI

const _FONT_CACHE := {}

static func get_default_font() -> Font:
    if _FONT_CACHE.has("default"):
        return _FONT_CACHE["default"]

    var font := Control.new().get_font("font")
    _FONT_CACHE["default"] = font
    return font
