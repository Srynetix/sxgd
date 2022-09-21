# A simple scene transition node, with a fade-in/fade-out effect.
extends CanvasLayer
class_name SxSceneTransitioner

# Transition is finished.
signal animation_finished()

onready var overlay := $Overlay as ColorRect
onready var animation_player := $AnimationPlayer as AnimationPlayer

# Fade current scene to another loaded scene.
#
# Example:
#   SxSceneTransitioner.fade_to_scene(my_scene)
func fade_to_scene(scene: PackedScene, speed: float = 1.0) -> void:
    animation_player.play("fade_out", -1, speed)
    yield(animation_player, "animation_finished")

    get_tree().change_scene_to(scene)
    animation_player.play("fade_in")

# Fade current scene to another scene, loaded before the process.
#
# Example:
#   SxSceneTransitioner.fade_to_scene_path("res://my_scene.tscn")
func fade_to_scene_path(scene_path: String, speed: float = 1.0) -> void:
    animation_player.play("fade_out", -1, speed)
    var scene := load(scene_path) as PackedScene
    yield(animation_player, "animation_finished")

    get_tree().change_scene_to(scene)
    animation_player.play("fade_in")

# Fade current scene to another scene, using a SxLoadCache.
#
# Example:
#   SxSceneTransitioner.fade_to_cached_scene(cache, "MyScene")
func fade_to_cached_scene(cache: SxLoadCache, scene_name: String, speed: float = 1.0) -> void:
    animation_player.play("fade_out", -1, speed)
    var scene := cache.load_scene(scene_name)
    yield(animation_player, "animation_finished")

    get_tree().change_scene_to(scene)
    animation_player.play("fade_in")

# Apply a "fade out" effect.
#
# Example:
#   SxSceneTransitioner.fade_out()
func fade_out(speed: float = 1.0) -> void:
    animation_player.play("fade_out", -1, speed)
    yield(animation_player, "animation_finished")

    emit_signal("animation_finished")

# Apply a "fade in" effect.
#
# Example:
#   SxSceneTransitioner.fade_in()
func fade_in(speed: float = 1.0) -> void:
    animation_player.play("fade_in", -1, speed)
    yield(animation_player, "animation_finished")

    emit_signal("animation_finished")
