extends Object
class_name SxUi

static func set_full_rect_no_mouse(node: Control) -> void:
    node.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    node.mouse_filter = Control.MOUSE_FILTER_IGNORE

static func set_margin_container_margins(node: MarginContainer, value: float) -> void:
    node.add_theme_constant_override("margin_right", value)
    node.add_theme_constant_override("margin_left", value)
    node.add_theme_constant_override("margin_top", value)
    node.add_theme_constant_override("margin_bottom", value)
