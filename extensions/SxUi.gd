extends Object
class_name SxUi

static func get_default_font() -> Font:
    SxAttr.setup_static_attribute("SxUi", "default_font", null)
    if SxAttr.has_static_attribute("SxUi", "default_font"):
        return SxAttr.get_static_attribute("SxUi", "default_font")

    var font := Control.new().get_theme_default_font()
    SxAttr.setup_static_attribute("SxUi", "default_font", font)
    return font

static func set_full_rect_no_mouse(node: Control) -> void:
    node.set_anchors_and_margins_preset(Control.PRESET_FULL_RECT)
    node.mouse_filter = Control.MOUSE_FILTER_IGNORE

static func set_margin_container_margins(node: MarginContainer, value: float) -> void:
    node.set("custom_constants/margin_right", value)
    node.set("custom_constants/margin_left", value)
    node.set("custom_constants/margin_top", value)
    node.set("custom_constants/margin_bottom", value)
