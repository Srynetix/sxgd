extends ColorRect
class_name SxNodeTracerUI

const FONT_DATA = preload("res://addons/sxgd/assets/fonts/OfficeCodePro-Regular.otf")

var _tree_items := {}
var _tree: Tree

func _ready() -> void:
    var box := StyleBoxEmpty.new()
    var font := DynamicFont.new()
    font.size = 12
    font.outline_size = 1
    font.outline_color = Color(0, 0, 0, 0.50)
    font.use_filter = true
    font.font_data = FONT_DATA

    anchor_right = 1.0
    anchor_bottom = 1.0
    size_flags_horizontal = Control.SIZE_EXPAND_FILL
    size_flags_vertical = Control.SIZE_EXPAND_FILL
    color = Color(0, 0, 0, 0.12)

    var margin := MarginContainer.new()
    margin.anchor_right = 1.0
    margin.anchor_bottom = 1.0
    margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    margin.size_flags_vertical = Control.SIZE_EXPAND_FILL
    margin.set("custom_constants/margin_right", 10)
    margin.set("custom_constants/margin_top", 10)
    margin.set("custom_constants/margin_left", 10)
    margin.set("custom_constants/margin_bottom", 10)
    add_child(margin)

    _tree = Tree.new()
    _tree.size_flags_vertical = Control.SIZE_EXPAND_FILL
    _tree.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    _tree.set("custom_styles/selected_focus", box)
    _tree.set("custom_styles/bg_focus", box)
    _tree.set("custom_styles/selected", box)
    _tree.set("custom_styles/bg", box)
    _tree.set("custom_fonts/font", font)
    _tree.set("custom_colors/font_color", Color.white)
    _tree.columns = 2
    _tree.select_mode = Tree.SELECT_ROW
    margin.add_child(_tree)

    _tree.create_item()

func update_using_tracer(tracer: SxNodeTracer) -> void:
    _tree.get_root().set_text(0, tracer.title)
    for key in tracer.parameters:
        var value = tracer.parameters[key]
        _trace_parameter(key, value)

func _create_parameter(key: String, value) -> void:
    var root := _tree.get_root()
    var item := _tree.create_item(root)
    _tree_items[key] = item

    item.set_text(0, key)
    item.set_text(1, value)

func _trace_parameter(key: String, value) -> void:
    if _tree_items.has(key):
        _tree_items[key].set_text(1, value)
    else:
        _create_parameter(key, value)
