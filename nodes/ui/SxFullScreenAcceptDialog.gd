tool
extends SxFullScreenDialog
class_name SxFullScreenAcceptDialog

export(String, MULTILINE) var message := "Message." setget _set_message
export(String) var ok_message := "OK" setget _set_ok_message

var _tween: Tween
var _message_label: Label
var _ok_btn: Button

signal confirmed()

func _build_ui_accept() -> void:
    var font := DynamicFont.new()
    font.size = 32
    font.font_data = FONT_DATA

    _tween = Tween.new()
    add_child(_tween)

    var inner_vbox := VBoxContainer.new()
    inner_vbox.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_SHRINK_CENTER
    inner_vbox.set("custom_constants/separation", 48)
    _vbox_container.add_child(inner_vbox)

    _message_label = Label.new()
    _message_label.set("custom_fonts/font", font)
    _message_label.text = message
    _message_label.align = Label.ALIGN_CENTER
    _message_label.valign = Label.VALIGN_CENTER
    _message_label.autowrap = true
    inner_vbox.add_child(_message_label)

    var hbox_container := HBoxContainer.new()
    hbox_container.set("custom_constants/separation", 80)
    hbox_container.alignment = HBoxContainer.ALIGN_CENTER
    inner_vbox.add_child(hbox_container)

    _ok_btn = Button.new()
    _ok_btn.set("custom_fonts/font", font)
    _ok_btn.text = ok_message
    _ok_btn.flat = true
    hbox_container.add_child(_ok_btn)

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
    _build_ui_accept()

    visible = false
    show_title = false

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
