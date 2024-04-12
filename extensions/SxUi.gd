extends Object
class_name SxUi
## UI extensions.
##
## Additional methods to work with UI nodes.

## Helper to set a [Control] to a "full rect" preset with an "ignore" mouse filter.
static func set_full_rect_no_mouse(node: Control) -> void:
    node.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    node.mouse_filter = Control.MOUSE_FILTER_IGNORE

## Helper to set uniform margins on a [MarginContainer].
static func set_margin_container_margins(node: MarginContainer, value: float) -> void:
    node.add_theme_constant_override("margin_right", value)
    node.add_theme_constant_override("margin_left", value)
    node.add_theme_constant_override("margin_top", value)
    node.add_theme_constant_override("margin_bottom", value)
