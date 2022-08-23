extends ColorRect
class_name SxNodeTracerUI

var _tree_items := {}

onready var _tree := $Margin/Tree as Tree

func _ready() -> void:
    _tree.create_item()

static func create_instance():
    var scene := load("res://addons/sxgd/nodes/debug/SxNodeTracer/SxNodeTracerUI.tscn") as PackedScene
    return scene.instance()

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
