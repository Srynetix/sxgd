extends Node
class_name SxCVars
## Console variables (CVars) system, inspired by Quake/Source.

class CVarUnit:
    extends RefCounted

    signal value_changed(value: Variant)

    var _name: String
    var _value: Variant

    var name: String:
        get:
            return _name

    var value: Variant:
        get:
            return _value
        set(value):
            _value = value
            value_changed.emit(_value)

    func _init(name: String, value: Variant):
        _name = name
        _value = value

static var _units: Dictionary = {}

static func _register_unit(unit: CVarUnit) -> void:
    if !_units.has(unit._name):
        _units[unit._name] = unit

static func register(name: String, initial_value: Variant) -> CVarUnit:
    var unit := CVarUnit.new(name, initial_value)
    _register_unit(unit)
    return unit

static func list_units() -> Array[SxCVars.CVarUnit]:
    var typed: Array[SxCVars.CVarUnit]
    typed.assign(_units.values())
    return typed

## Get a known CVar unit.
static func get_unit(name: String) -> CVarUnit:
    return _units[name]

## Get a known CVar value.
static func get_cvar(name: String) -> Variant:
    if name in _units:
        return _units[name].value
    return null

## Set a known CVar value.
static func set_cvar(name: String, value: Variant) -> void:
    if name in _units:
        _units[name].value = value
