extends Node
class_name SxDecalController
## Decal controller.
##
## Used to control decal counts on the scene.

class SxDecalVarCollection:
    extends SxCVars.VarCollection

    var SxDecalControllerMaxDecals := 10

var _decals: Array[SxDecal] = []

## Spawn a decal.
func spawn_decal(decal_scene: PackedScene, parent: Node3D, position: Vector3, normal: Vector3) -> void:
    while len(_decals) > SxCVars.get_cvar("SxDecalControllerMaxDecals"):
        var decal_to_remove = _decals[0]
        _decals.remove_at(0)
        decal_to_remove.queue_free()

    var decal: SxDecal = decal_scene.instantiate()
    parent.add_child(decal)
    decal.global_position = position
    decal.align_with_normal(normal)
    _decals.append(decal)

## Check if the global controller is available.
static func is_available(tree: SceneTree) -> bool:
    return tree.root.has_node("SxDecalController")

## Get or create a global controller instance.
static func get_global_instance(tree: SceneTree) -> SxDecalController:
    if !is_available(tree):
        var instance = SxDecalController.new()
        tree.root.add_child(instance)
        return instance

    return tree.root.get_node("SxDecalController")

func _ready():
    name = "SxDecalController"
    SxCVars.bind_collection(SxDecalVarCollection.new())
