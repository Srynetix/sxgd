extends ColorRect
class_name SxNodeTracerUi
## Node tracer UI component.
##
## Used in [SxDebugTools].

const _FONT = preload("res://addons/sxgd/assets/fonts/OfficeCodePro-Regular.otf")

var _tree_items := {}
var _tree: Tree

## Update UI using a tracer.
func update_using_tracer(tracer: SxNodeTracer) -> void:
    _tree.get_root().set_text(0, tracer.title)
    for key in tracer.parameters:
        var value = tracer.parameters[key]
        _trace_parameter(key, value)

func _ready() -> void:
    var box := StyleBoxEmpty.new()

    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    size_flags_horizontal = Control.SIZE_EXPAND_FILL
    size_flags_vertical = Control.SIZE_EXPAND_FILL
    color = Color(0, 0, 0, 0.12)

    var margin := MarginContainer.new()
    margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    margin.size_flags_vertical = Control.SIZE_EXPAND_FILL
    margin.add_theme_constant_override("margin_right", 10)
    margin.add_theme_constant_override("margin_top", 10)
    margin.add_theme_constant_override("margin_left", 10)
    margin.add_theme_constant_override("margin_bottom", 10)
    add_child(margin)

    _tree = Tree.new()
    _tree.size_flags_vertical = Control.SIZE_EXPAND_FILL
    _tree.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    _tree.add_theme_stylebox_override("selected_focus", box)
    _tree.add_theme_stylebox_override("focus", box)
    _tree.add_theme_stylebox_override("selected", box)
    _tree.add_theme_stylebox_override("panel", box)
    _tree.add_theme_font_override("font", _FONT)
    _tree.add_theme_font_size_override("font_size", 12)
    _tree.add_theme_constant_override("outline_size", 3)
    _tree.add_theme_color_override("font_color", Color.WHITE)
    _tree.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.50))
    _tree.columns = 2
    _tree.select_mode = Tree.SELECT_ROW
    margin.add_child(_tree)

    _tree.create_item()

func _create_parameter(key: String, value: Variant) -> void:
    var root := _tree.get_root()
    var item := _tree.create_item(root)
    _tree_items[key] = item

    item.set_text(0, key)
    item.set_text(1, value)

func _trace_parameter(key: String, value: Variant) -> void:
    if _tree_items.has(key):
        _tree_items[key].set_text(1, value)
    else:
        _create_parameter(key, value)
