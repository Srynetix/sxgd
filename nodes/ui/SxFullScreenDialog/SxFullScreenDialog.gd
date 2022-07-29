tool
extends Panel
class_name SxFullScreenDialog

export var title := "Dialog title" setget _set_dialog_title
export var autohide := true

onready var _title_label := $MarginContainer/VBoxContainer/Title as Label

func _set_dialog_title(value: String) -> void:
    title = value
    if _title_label == null:
        yield(self, "ready")
    _title_label.text = value

func _ready() -> void:
    _title_label.text = title

func show() -> void:
    visible = true

func hide() -> void:
    visible = false
