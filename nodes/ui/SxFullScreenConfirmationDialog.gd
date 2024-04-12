@tool
extends SxFullScreenDialog
class_name SxFullScreenConfirmationDialog
## Simple full-screen confirmation dialog.

## Message to display.
@export_multiline var message := "Are you sure?" : set = _set_message
## Label for the confirmation button.
@export var yes_message := "Yes" : set = _set_yes_message
## Label for the cancellation button.
@export var no_message := "No" : set = _set_no_message

var _message_label: Label
var _yes_btn: Button
var _no_btn: Button

## On dialog confirmed.
signal confirmed()
## On dialog canceled.
signal canceled()

func _build_ui_confirmation() -> void:
    var inner_vbox := VBoxContainer.new()
    inner_vbox.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_SHRINK_CENTER
    inner_vbox.add_theme_constant_override("separation", 48)
    _vbox_container.add_child(inner_vbox)

    _message_label = Label.new()
    _message_label.add_theme_font_override("font", _FONT)
    _message_label.add_theme_font_size_override("font_size", 32)
    _message_label.text = message
    _message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    _message_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    _message_label.autowrap_mode = TextServer.AUTOWRAP_WORD
    inner_vbox.add_child(_message_label)

    var hbox_container := HBoxContainer.new()
    hbox_container.add_theme_constant_override("separation", 80)
    hbox_container.alignment = HBoxContainer.ALIGNMENT_CENTER
    inner_vbox.add_child(hbox_container)

    _yes_btn = Button.new()
    _yes_btn.add_theme_font_override("font", _FONT)
    _yes_btn.add_theme_font_size_override("font_size", 32)
    _yes_btn.text = yes_message
    _yes_btn.flat = true
    hbox_container.add_child(_yes_btn)

    _no_btn = Button.new()
    _no_btn.add_theme_font_override("font", _FONT)
    _no_btn.add_theme_font_size_override("font_size", 32)
    _no_btn.text = no_message
    _no_btn.flat = true
    hbox_container.add_child(_no_btn)

func _set_message(value: String):
    message = value
    if !_message_label:
        await self.ready
    _message_label.text = value

func _set_yes_message(value: String):
    yes_message = value
    if !_yes_btn:
        await self.ready
    _yes_btn.text = yes_message

func _set_no_message(value: String):
    no_message = value
    if !_no_btn:
        await self.ready
    _no_btn.text = no_message

func _ready() -> void:
    super._ready()
    _build_ui_confirmation()

    show_title = false

    _message_label.text = message
    _yes_btn.pressed.connect(_on_yes)
    _no_btn.pressed.connect(_on_no)

func _on_yes() -> void:
    hide_dialog()
    emit_signal(confirmed.get_name())

func _on_no() -> void:
    hide_dialog()
    emit_signal(canceled.get_name())
