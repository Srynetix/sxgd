extends CanvasLayer
class_name SxSceneTransitioner

# Transition is finished.
signal animation_finished()

onready var overlay: ColorRect = $Overlay
onready var animation_player: AnimationPlayer = $AnimationPlayer

# Fade current scene to another loaded scene.
#
# Example:
#   SxSceneTransitioner.fade_to_scene(my_scene)
func fade_to_scene(scene: PackedScene) -> void:
    animation_player.play("fade_out")
    yield(animation_player, "animation_finished")

    get_tree().change_scene_to(scene)
    animation_player.play("fade_in")

# Fade current scene to another scene, loaded before the process.
#
# Example:
#   SxSceneTransitioner.fade_to_scene_path("res://my_scene.tscn")
func fade_to_scene_path(scene_path: String) -> void:
    animation_player.play("fade_out")
    var scene: PackedScene = load(scene_path)
    yield(animation_player, "animation_finished")

    get_tree().change_scene_to(scene)
    animation_player.play("fade_in")

# Apply a "fade out" effect.
#
# Example:
#   SxSceneTransitioner.fade_out()
func fade_out() -> void:
    animation_player.play("fade_out")
    yield(animation_player, "animation_finished")

    emit_signal("animation_finished")

# Apply a "fade in" effect.
#
# Example:
#   SxSceneTransitioner.fade_in()
func fade_in() -> void:
    animation_player.play("fade_in")
    yield(animation_player, "animation_finished")

    emit_signal("animation_finished")
