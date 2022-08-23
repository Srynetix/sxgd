extends Node
class_name SxNodeTracer

const NONAME = "__noname__"

export var title: String

var parameters := {}

func _init(name: String = NONAME) -> void:
    self.name = name
    title = name

func _ready() -> void:
    if title == NONAME:
        title = get_parent().get_path()

    add_to_group("NodeTracer")

func trace_parameter(name: String, value) -> void:
    parameters[name] = _stringify_value(value)

func _stringify_value(value) -> String:
    if value is bool:
        if value:
            return "YES"
        else:
            return "NO"

    if value is Vector3:
        return "(%0.2f, %0.2f, %0.2f)" % [value.x, value.y, value.z]

    return str(value)
