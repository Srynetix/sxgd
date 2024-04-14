extends Node3D
class_name SxFPSWeapon
## FPS weapon.

## Cooldown in seconds.
@export var cooldown_seconds: float = 0.1: set = _set_cooldown_seconds
## Target raycast.
@export var raycast: RayCast3D
## Decal scene to spawn on contact.
@export var decal_scene: PackedScene

## Associated FPS controller.
var controller: SxFPSController

var _can_shoot := true
var _cooldown_timer: Timer

## Fire!
func fire() -> void:
    if _can_shoot:
        _can_shoot = false
        _cooldown_timer.start()
        _on_fire()

## Release fire.
func release() -> void:
    _on_release()

func _ready() -> void:
    _cooldown_timer = Timer.new()
    _cooldown_timer.wait_time = cooldown_seconds
    _cooldown_timer.one_shot = true
    _cooldown_timer.timeout.connect(func(): _can_shoot = true)
    add_child(_cooldown_timer)

func _on_release() -> void:
    pass

func _on_fire() -> void:
    pass

func _spawn_decal(parent: Node3D, decal_position: Vector3, normal: Vector3):
    var decal_controller := SxDecalController.get_global_instance(get_tree())
    decal_controller.spawn_decal(decal_scene, parent, decal_position, normal)

func _set_cooldown_seconds(value: float) -> void:
    if _cooldown_timer == null:
        await self.ready

    cooldown_seconds = value
    _cooldown_timer.wait_time = value
