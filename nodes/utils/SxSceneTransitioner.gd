extends CanvasLayer
class_name SxSceneTransitioner
## A simple scene transition node, with a fade-in/fade-out effect.

## Transition is finished.
signal finished()

const COLOR_TRANSPARENT_BLACK := Color(0, 0, 0, 0)

var _overlay: ColorRect

## Setup a global instance.
static func setup_global_instance(tree: SceneTree):
    if !tree.root.has_node("SxSceneTransitioner"):
        tree.root.call_deferred("add_child", SxSceneTransitioner.new())
        await tree.process_frame

## Get a global instance.
static func get_global_instance(tree: SceneTree) -> SxSceneTransitioner:
    return tree.root.get_node("SxSceneTransitioner")

## Fade current scene to another loaded scene.[br]
##
## Usage:
## [codeblock]
## SxSceneTransitioner.fade_to_scene(my_scene)
## [/codeblock]
func fade_to_scene(scene: PackedScene, duration: float = 1.0, interpolation: int = Tween.TRANS_LINEAR) -> void:
    await _tween_fade_out(duration, interpolation)

    get_tree().change_scene_to_packed(scene)
    await _tween_fade_in(duration, interpolation)

## Fade current scene to another scene, loaded before the process.[br]
##
## Usage:
## [codeblock]
## SxSceneTransitioner.fade_to_scene_path("res://my_scene.tscn")
## [/codeblock]
func fade_to_scene_path(scene_path: String, duration: float = 1.0, interpolation: int = Tween.TRANS_LINEAR) -> void:
    var scene := load(scene_path) as PackedScene
    await _tween_fade_out(duration, interpolation)

    get_tree().change_scene_to_packed(scene)
    await _tween_fade_in(duration, interpolation)

## Fade current scene to another scene, using a SxLoadCache.[br]
##
## Usage:
## [codeblock]
## SxSceneTransitioner.fade_to_cached_scene(cache, "MyScene")
## [/codeblock]
func fade_to_cached_scene(cache: SxLoadCache, scene_name: String, duration: float = 1.0, interpolation: int = Tween.TRANS_LINEAR) -> void:
    var scene := cache.load_scene(scene_name)
    await _tween_fade_out(duration, interpolation)

    get_tree().change_scene_to_packed(scene)
    await _tween_fade_in(duration, interpolation)

## Apply a "fade out" effect.[br]
##
## Usage:
## [codeblock]
## SxSceneTransitioner.fade_out()
## [/codeblock]
func fade_out(duration: float = 1.0, interpolation: int = Tween.TRANS_LINEAR) -> void:
    await _tween_fade_out(duration, interpolation)
    emit_signal("finished")

## Apply a "fade in" effect.[br]
##
## Usage:
## [codeblock]
## SxSceneTransitioner.fade_in()
## [/codeblock]
func fade_in(duration: float = 1.0, interpolation: int = Tween.TRANS_LINEAR) -> void:
    await _tween_fade_in(duration, interpolation)
    emit_signal("finished")

func _init() -> void:
    name = "SxSceneTransitioner"

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
