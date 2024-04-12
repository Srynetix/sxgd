@tool
extends SxFullScreenDialog
class_name SxFullScreenAcceptDialog
## Simple full-screen accept dialog.

## Message to display.
@export_multiline var message := "Message." : set = _set_message
## Label for the accept button.
@export var ok_message := "OK" : set = _set_ok_message

var _message_label: Label
var _ok_btn: Button

## On dialog acceptation.
signal confirmed()

func _build_ui_accept() -> void:
    var inner_vbox := VBoxContainer.new()
    inner_vbox.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_SHRINK_CENTER
    inner_vbox.add_theme_constant_override("separation", 48)
    _vbox_container.add_child(inner_vbox)

    _message_label = Label.new()
    _message_label.add_theme_font_override("font", _FONT)
    _message_label.add_theme_font_size_override("font_size", 34)
    _message_label.text = message
    _message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    _message_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    _message_label.autowrap_mode = TextServer.AUTOWRAP_WORD
    inner_vbox.add_child(_message_label)

    var hbox_container := HBoxContainer.new()
    hbox_container.add_theme_constant_override("separation", 80)
    hbox_container.alignment = HBoxContainer.ALIGNMENT_CENTER
    inner_vbox.add_child(hbox_container)

    _ok_btn = Button.new()
    _ok_btn.add_theme_font_override("font", _FONT)
    _ok_btn.add_theme_font_size_override("font_size", 34)
    _ok_btn.text = ok_message
    _ok_btn.flat = true
    hbox_container.add_child(_ok_btn)

func _set_message(value: String):
    message = value
    if !_message_label:
        await self.ready
    _message_label.text = value

func _set_ok_message(value: String):
    ok_message = value
    if !_ok_btn:
        await self.ready
    _ok_btn.text = ok_message

func _ready() -> void:
    super._ready()
    _build_ui_accept()

    show_title = false

    _message_label.text = message
    _ok_btn.text = ok_message
    _ok_btn.pressed.connect(_on_ok)

func _on_ok() -> void:
    hide_dialog()
    emit_signal(confirmed.get_name())
