extends Node
class_name SxCVars

const SENTINEL = Object()

class _Vars:
    extends Object

    var sample := ""

var _vars := _Vars.new()

func get_cvar(name: String):
    return _vars.get(name)

func set_cvar(name: String, value):
    _vars.set(name, value)

func print_cvars() -> String:
    var output := ""
    var plist := _vars.get_property_list()
    for p in plist:
        if p["usage"] == PROPERTY_USAGE_SCRIPT_VARIABLE:
            var value = _vars.get(p["name"])
            output += "%s (%s)\n" % [p["name"], value]
    if output != "":
        output = output.substr(0, len(output) - 1)
    return output
