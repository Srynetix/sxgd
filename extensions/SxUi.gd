extends Reference
class_name SxUi

const _FONT_CACHE := {}

static func get_default_font() -> Font:
    if _FONT_CACHE.has("default"):
        return _FONT_CACHE["default"]

    var font := Control.new().get_font("font")
    _FONT_CACHE["default"] = font
    return font

static func set_full_rect_no_mouse(node: Control) -> void:
    node.set_anchors_and_margins_preset(Control.PRESET_WIDE)
    node.mouse_filter = Control.MOUSE_FILTER_IGNORE

static func set_margin_container_margins(node: MarginContainer, value: float) -> void:
    node.set("custom_constants/margin_right", value)
    node.set("custom_constants/margin_left", value)
    node.set("custom_constants/margin_top", value)
    node.set("custom_constants/margin_bottom", value)
