extends Node3D
class_name SxZoneLimitsTracker
## A tracker for [SxZoneLimits].
##
## Must be attached to a node inheriting from [Node3D].

## Tracker was reset.
signal reset()

var _parent: Node3D
var _initial_parent_position: Vector3

func _ready() -> void:
    add_to_group("SxZoneLimitsTracker")

    var parent = get_parent()
    assert(parent is Node3D, "SxZoneLimitsTracker nodes should be instantiated as child of a Node3D node")

    _parent = parent as Node3D
    _initial_parent_position = _parent.global_transform.origin

func reset_parent_position() -> void:
    _parent.global_transform.origin = _initial_parent_position
    reset.emit()
