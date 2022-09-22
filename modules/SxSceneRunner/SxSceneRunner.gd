# Scene runner, can be used as a test suite.
# Inherit the scene, define a "scene_folder", then you can navigate scenes.

extends Control
class_name SxSceneRunner

signal scene_loaded(name)
signal go_back()

export var show_back_button := true
export(String, DIR) var scene_folder: String

const SCENE_KEY_RESET := KEY_I
const SCENE_KEY_PREV := KEY_O
const SCENE_KEY_NEXT := KEY_P

onready var _current := $Current as Control
onready var _scene_name := $CanvasLayer/Margin/VBox/Text/SceneName as Label
onready var _back_button := $CanvasLayer/Margin/BackButton as Button
onready var _previous_btn := $CanvasLayer/Margin/VBox/Margin/Buttons/Previous as Button
onready var _reset_btn := $CanvasLayer/Margin/VBox/Margin/Buttons/Reset as Button
onready var _next_btn := $CanvasLayer/Margin/VBox/Margin/Buttons/Next as Button

var _known_scenes := []
var _current_scene := 0

func _ready() -> void:
    if !show_back_button:
        _back_button.hide()

    _known_scenes = _discover_scenes()
    _load_first_scene()

    _previous_btn.connect("pressed", self, "_load_prev_scene")
    _reset_btn.connect("pressed", self, "_load_current_scene")
    _next_btn.connect("pressed", self, "_load_next_scene")
    _back_button.connect("pressed", self, "_go_back")

func _input(event: InputEvent) -> void:
    if event is InputEventKey:
        var key_event := event as InputEventKey
        if key_event.pressed:
            if key_event.scancode == SCENE_KEY_NEXT:
                _load_next_scene()
            elif key_event.scancode == SCENE_KEY_PREV:
                _load_prev_scene()
            elif key_event.scancode == SCENE_KEY_RESET:
                _load_current_scene()
            elif key_event.scancode == KEY_ESCAPE:
                _go_back()

func _notification(what: int) -> void:
    if what == NOTIFICATION_WM_GO_BACK_REQUEST:
        _go_back()

func _load_first_scene() -> void:
    if len(_known_scenes) == 0:
        _scene_name.text = "[NO SCENE FOUND]"
        return

    _load_current_scene()

func _discover_scenes() -> Array:
    var scenes := []
    var dir := Directory.new()
    var idx := 1

    # Stop on empty scene folder
    if scene_folder == "":
        return scenes

    dir.open(scene_folder)
    dir.list_dir_begin()

    while true:
        var file := dir.get_next()
        if file == "":
            break

        if file.ends_with(".tscn"):
            scenes.append([idx, file.trim_suffix(".tscn"), load(scene_folder + "/" + file)])
            idx += 1

    dir.list_dir_end()
    return scenes

func _load_current_scene() -> void:
    var entry := _known_scenes[_current_scene] as Array
    var entry_idx := entry[0] as int
    var entry_name := entry[1] as String
    var entry_model := entry[2] as PackedScene

    # Clear previous
    for child in _current.get_children():
        child.queue_free()

    # Load instance
    var instance := entry_model.instance()
    _scene_name.text = str(entry_idx) + " - " + entry_name + "\n" + str(entry_idx) + "/" + str(len(_known_scenes))
    _current.add_child(instance)
    emit_signal("scene_loaded", entry_name)

func _load_next_scene() -> void:
    if _current_scene == len(_known_scenes) - 1:
        _current_scene = 0
    else:
        _current_scene += 1
    _load_current_scene()

func _load_prev_scene() -> void:
    if _current_scene == 0:
        _current_scene = len(_known_scenes) - 1
    else:
        _current_scene -= 1
    _load_current_scene()

func _go_back():
    _back_button.mouse_filter = MOUSE_FILTER_IGNORE
    emit_signal("go_back")
