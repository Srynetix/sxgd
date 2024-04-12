@tool
extends Node3D
class_name SxZoneLimits
## Delimits a 3D zone.
##
## Tracks [SxZoneLimitsTracker]s. If a tracker exits the zone, it will be reset to its initial position.

## Zone limits.
@export var limits: Vector3 = Vector3(100, 100, 100) : set = _set_limits

var _mesh: BoxMesh

func _ready() -> void:
    var mesh_instance := MeshInstance3D.new()
    add_child(mesh_instance)

    var material := StandardMaterial3D.new()
    material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    material.albedo_color = Color(1, 0, 0, 0.117)
    material.cull_mode = BaseMaterial3D.CULL_DISABLED

    _mesh = BoxMesh.new()
    _mesh.size = limits
    _mesh.material = material

    mesh_instance.mesh = _mesh

    if !Engine.is_editor_hint():
        visible = false

func _set_limits(value: Vector3) -> void:
    limits = value

    if !_mesh:
        await self.ready

    _mesh.size = limits

func _process(_delta: float) -> void:
    if Engine.is_editor_hint():
        return

    var bbox := AABB(global_transform.origin - limits / 2, limits)
    for node in get_tree().get_nodes_in_group("SxZoneLimitsTracker"):
        var tracker := node as SxZoneLimitsTracker
        if !bbox.has_point(tracker.global_transform.origin):
            tracker.reset_parent_position()
