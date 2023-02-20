tool
extends SxFullScreenDialog
class_name SxFullScreenConfirmationDialog

export(String, MULTILINE) var message := "Are you sure?" setget _set_message
export(String) var yes_message := "Yes" setget _set_yes_message
export(String) var no_message := "No" setget _set_no_message

var _tween: Tween
var _message_label: Label
var _yes_btn: Button
var _no_btn: Button

signal confirmed()
signal canceled()

func _build_ui_confirmation() -> void:
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

    _yes_btn = Button.new()
    _yes_btn.set("custom_fonts/font", font)
    _yes_btn.text = yes_message
    _yes_btn.flat = true
    hbox_container.add_child(_yes_btn)

    _no_btn = Button.new()
    _no_btn.set("custom_fonts/font", font)
    _no_btn.text = no_message
    _no_btn.flat = true
    hbox_container.add_child(_no_btn)

func _set_message(value: String):
    message = value
    if !_message_label:
        yield(self, "ready")
    _message_label.text = value

func _set_yes_message(value: String):
    yes_message = value
    if !_yes_btn:
        yield(self, "ready")
    _yes_btn.text = yes_message

func _set_no_message(value: String):
    no_message = value
    if !_no_btn:
        yield(self, "ready")
    _no_btn.text = no_message

func _ready() -> void:
    _build_ui_confirmation()

    visible = false
    show_title = false

    _message_label.text = message
    _yes_btn.connect("pressed", self, "_on_yes")
    _no_btn.connect("pressed", self, "_on_no")

func _on_yes() -> void:
    hide()
    emit_signal("confirmed")

func _on_no() -> void:
    hide()
    emit_signal("canceled")

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
