tool
extends SxFullScreenDialog
class_name SxFullScreenAcceptDialog

export(String, MULTILINE) var message := "Message." setget _set_message
export(String) var ok_message := "OK" setget _set_ok_message

onready var _tween := $Tween as Tween
onready var _message_label := $MarginContainer/VBoxContainer/VBoxContainer/Content as Label
onready var _ok_btn := $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/OK as Button

signal confirmed()

const _cache = {};

func _set_message(value: String):
    message = value
    if !_message_label:
        yield(self, "ready")
    _message_label.text = value

func _set_ok_message(value: String):
    ok_message = value
    if !_ok_btn:
        yield(self, "ready")
    _ok_btn.text = ok_message

func _ready() -> void:
    visible = false
    _message_label.text = message
    _ok_btn.text = ok_message
    _ok_btn.connect("pressed", self, "_on_ok")

func _on_ok() -> void:
    hide()
    emit_signal("confirmed")

func show() -> void:
    _tween.stop_all()
    visible = true
    _tween.interpolate_property(self, "modulate", Color.transparent, Color.white, 0.25, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
    _tween.start()

func hide() -> void:
    _tween.stop_all()
    _tween.interpolate_property(self, "modulate", Color.white, Color.transparent, 0.25, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
    _tween.start()
    yield(_tween, "tween_all_completed")
    visible = false

static func instance() -> Node:
    return _load_scene().instance()

static func _load_scene() -> PackedScene:
    if _cache.has("scene"):
        return _cache["scene"]

    var scene := load("res://addons/sxgd/nodes/ui/SxFullScreenAcceptDialog/SxFullScreenAcceptDialog.tscn") as PackedScene
    _cache["scene"] = scene
    return scene
