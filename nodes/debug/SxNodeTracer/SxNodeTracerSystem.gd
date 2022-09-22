extends MarginContainer
class_name SxNodeTracerSystem

var _tracers := {}
var _tracers_ui := {}
var _logger := SxLog.get_logger("SxNodeTracerSystem")

onready var _grid := $Container/MarginContainer2/Grid as GridContainer

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
    var ui = SxNodeTracerUI.create_instance() as SxNodeTracerUI
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
