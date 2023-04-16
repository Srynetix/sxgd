# A simple scene transition node, with a fade-in/fade-out effect.
extends CanvasLayer
class_name SxSceneTransitioner

# Transition is finished.
signal finished()

const COLOR_TRANSPARENT_BLACK := Color(0, 0, 0, 0)

var _overlay: ColorRect

func _ready() -> void:
    layer = 10

    _overlay = ColorRect.new()
    _overlay.name = "Overlay"
    _overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    _overlay.color = COLOR_TRANSPARENT_BLACK
    _overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(_overlay)

func _tween_fade_out(duration: float, interpolation: int) -> void:
    _overlay.color = COLOR_TRANSPARENT_BLACK
    _overlay.mouse_filter = Control.MOUSE_FILTER_STOP

    var tween = create_tween()
    tween.tween_property(_overlay, "color", Color.BLACK, duration).set_trans(interpolation)
    await tween.finished

func _tween_fade_in(duration: float, interpolation: int) -> void:
    _overlay.color = Color.BLACK
    _overlay.mouse_filter = Control.MOUSE_FILTER_STOP

    var tween = create_tween()
    tween.tween_property(_overlay, "color", COLOR_TRANSPARENT_BLACK, duration).set_trans(interpolation)
    await tween.finished

    _overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE

# Fade current scene to another loaded scene.
#
# Example:
#   SxSceneTransitioner.fade_to_scene(my_scene)
func fade_to_scene(scene: PackedScene, duration: float = 1.0, interpolation: int = Tween.TRANS_LINEAR) -> void:
    await _tween_fade_out(duration, interpolation)

    get_tree().change_scene_to_packed(scene)
    await _tween_fade_in(duration, interpolation)

# Fade current scene to another scene, loaded before the process.
#
# Example:
#   SxSceneTransitioner.fade_to_scene_path("res://my_scene.tscn")
func fade_to_scene_path(scene_path: String, duration: float = 1.0, interpolation: int = Tween.TRANS_LINEAR) -> void:
    var scene := load(scene_path) as PackedScene
    await _tween_fade_out(duration, interpolation)

    get_tree().change_scene_to_packed(scene)
    await _tween_fade_in(duration, interpolation)

# Fade current scene to another scene, using a SxLoadCache.
#
# Example:
#   SxSceneTransitioner.fade_to_cached_scene(cache, "MyScene")
func fade_to_cached_scene(cache: SxLoadCache, scene_name: String, duration: float = 1.0, interpolation: int = Tween.TRANS_LINEAR) -> void:
    var scene := cache.load_scene(scene_name)
    await _tween_fade_out(duration, interpolation)

    get_tree().change_scene_to_packed(scene)
    await _tween_fade_in(duration, interpolation)

# Apply a "fade out" effect.
#
# Example:
#   SxSceneTransitioner.fade_out()
func fade_out(duration: float = 1.0, interpolation: int = Tween.TRANS_LINEAR) -> void:
    await _tween_fade_out(duration, interpolation)
    emit_signal("finished")

# Apply a "fade in" effect.
#
# Example:
#   SxSceneTransitioner.fade_in()
func fade_in(duration: float = 1.0, interpolation: int = Tween.TRANS_LINEAR) -> void:
    await _tween_fade_in(duration, interpolation)
    emit_signal("finished")
