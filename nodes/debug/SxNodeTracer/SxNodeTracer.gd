extends Node
class_name SxNodeTracer
## A node tracer to use with [SxNodeTracerSystem].

const NONAME = "__noname__"

## Title of the tracer.
@export var title: String

## Tracer parameters.
var parameters := {}

## Trace a parameter.
func trace_parameter(name: String, value: Variant) -> void:
    parameters[name] = _stringify_value(value)

func _init(name: String = NONAME) -> void:
    self.name = name
    title = name

func _ready() -> void:
    if title == NONAME:
        name = "SxNodeTracer"
        title = get_parent().get_path()

    add_to_group("SxNodeTracer")

func _stringify_value(value: Variant) -> String:
    if value is bool:
        if value:
            return "YES"
        else:
            return "NO"

    if value is Vector3:
        return "(%0.2f, %0.2f, %0.2f)" % [value.x, value.y, value.z]

    return str(value)
