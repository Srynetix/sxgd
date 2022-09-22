tool
extends SxFullScreenDialog
class_name SxFullScreenConfirmationDialog

export(String, MULTILINE) var message := "Are you sure?" setget _set_message

onready var tween := $Tween as Tween
onready var message_label := $MarginContainer/VBoxContainer/VBoxContainer/Content as Label
onready var yes_btn := $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Yes as Button
onready var no_btn := $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/No as Button

signal confirmed()
signal canceled()

func _set_message(value: String):
    message = value
    if !message_label:
        yield(self, "ready")
    message_label.text = value

func _ready() -> void:
    visible = false
    message_label.text = message
    yes_btn.connect("pressed", self, "_on_yes")
    no_btn.connect("pressed", self, "_on_no")

func _on_yes() -> void:
    hide()
    emit_signal("confirmed")

func _on_no() -> void:
    hide()
    emit_signal("canceled")

func show() -> void:
    tween.stop_all()
    visible = true
    tween.interpolate_property(self, "modulate", Color.transparent, Color.white, 0.25, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
    tween.start()

func hide() -> void:
    tween.stop_all()
    tween.interpolate_property(self, "modulate", Color.white, Color.transparent, 0.25, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
    tween.start()
    yield(tween, "tween_all_completed")
    visible = false
