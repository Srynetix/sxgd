tool
extends Panel
class_name SxFullScreenDialog

export var title := "Dialog title" setget _set_dialog_title
export var autohide := true
export var show_title := true setget _set_show_title

onready var _title_label := $MarginContainer/VBoxContainer/Title as Label

func _set_show_title(value: bool):
    show_title = value
    if !_title_label:
        yield(self, "ready")
    _title_label.visible = value

func _set_dialog_title(value: String) -> void:
    title = value
    if _title_label == null:
        yield(self, "ready")
    _title_label.text = value

func _ready() -> void:
    _title_label.text = title
    _title_label.visible = show_title

func show() -> void:
    visible = true

func hide() -> void:
    visible = false
