extends MarginContainer
class_name SxNodeTracerSystem

const FONT_DATA = preload("res://addons/sxgd/assets/fonts/OfficeCodePro-Bold.otf")

var _tracers := {}
var _tracers_ui := {}
var _logger := SxLog.get_logger("SxNodeTracerSystem")

var _grid: GridContainer

func _ready() -> void:
    var font := DynamicFont.new()
    font.size = 18
    font.outline_size = 1
    font.outline_color = Color.black
    font.use_filter = true
    font.font_data = FONT_DATA

    name = "SxNodeTracerSystem"
    set_anchors_and_margins_preset(Control.PRESET_WIDE)

    var vbox_container := VBoxContainer.new()
    vbox_container.set("custom_constants/separation", 0)
    add_child(vbox_container)

    var margin_container := MarginContainer.new()
    vbox_container.add_child(margin_container)

    var title := Label.new()
    title.size_flags_vertical = 0
    title.set("custom_fonts/font", font)
    title.text = " Node Tracer"
    margin_container.add_child(title)

    var margin_container2 := MarginContainer.new()
    margin_container2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    margin_container2.size_flags_vertical = Control.SIZE_EXPAND_FILL
    margin_container2.set("custom_constants/margin_right", 5)
    margin_container2.set("custom_constants/margin_top", 5)
    margin_container2.set("custom_constants/margin_left", 5)
    margin_container2.set("custom_constants/margin_bottom", 5)
    vbox_container.add_child(margin_container2)

    _grid = GridContainer.new()
    _grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    _grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
    _grid.columns = 2
    margin_container2.add_child(_grid)

func _process(delta: float) -> void:
    for node in get_tree().get_nodes_in_group("NodeTracer"):
        var tracer := node as SxNodeTracer
        var node_path := str(tracer.get_path())

        if !_tracers.has(node_path):
            _logger.debug_m("_process", "Registering NodeTracer '%s'." % tracer.title)
            _tracers[node_path] = node
            var ui := _create_tracer_ui(node_path, node)
            node.connect("tree_exiting", self, "_remove_tracer_ui", [node_path, ui])
        else:
            _update_tracer_ui(node, _tracers_ui[node_path])

func _create_tracer_ui(path: String, tracer: SxNodeTracer) -> SxNodeTracerUI:
    var ui = SxNodeTracerUI.new()
    _tracers_ui[path] = ui
    _grid.add_child(ui)
    _update_tracer_ui(tracer, ui)
    return ui

func _update_tracer_ui(tracer: SxNodeTracer, ui: SxNodeTracerUI) -> void:
    ui.update_using_tracer(tracer)

func _remove_tracer_ui(path: String, ui: SxNodeTracerUI) -> void:
    _tracers.erase(path)
    _tracers_ui.erase(path)
    _grid.remove_child(ui)
    ui.queue_free()
