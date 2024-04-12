extends Node
class_name SxCVars
## Console variables (CVars) system, inspired by Quake/Source.

## Variable collection.
##
## Inherit this class to define new CVars.
##
## Do not forget to register your collection using the [method bind_collection] method.
class VarCollection:
    extends Object

static var _collections: Array[VarCollection] = []
static var _data: Dictionary = {}

## Bind a [VarCollection] to the CVar system.
static func bind_collection(vars: VarCollection) -> void:
    var plist := vars.get_property_list()
    for p in plist:
        if p["usage"] == PROPERTY_USAGE_SCRIPT_VARIABLE:
            var name = p["name"]
            var value = vars.get(p["name"])

            if !_data.has(name):
                _data[name] = value

## Get a known CVar value.
static func get_cvar(name: String) -> Variant:
    return _data.get(name)

## Set a known CVar value.
static func set_cvar(name: String, value: Variant) -> void:
    if _data.has(name):
        _data[name] = value

## Print available CVars into a string.
static func print_cvars() -> String:
    var output := ""
    for cvar in _data:
        var value = _data[cvar]
        output += "%s (%s)\n" % [cvar, value]

    if output != "":
        output = output.substr(0, len(output) - 1)

    return output
