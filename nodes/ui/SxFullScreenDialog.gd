@tool
extends Panel
class_name SxFullScreenDialog

const font := preload("res://addons/sxgd/assets/fonts/Jost-800-Heavy.ttf")

@export var title := "Dialog title" : set = _set_dialog_title
@export var autohide := true
@export var show_title := true : set = _set_show_title

var _tween: Tween
var _title_label: Label
var _vbox_container: VBoxContainer

func _build_ui() -> void:
    var background_style = StyleBoxFlat.new()
    background_style.bg_color = Color.BLACK
    add_theme_stylebox_override("panel", background_style)

    var margin_container := MarginContainer.new()
    margin_container.name = "MarginContainer"
    margin_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    SxUi.set_margin_container_margins(margin_container, 20)
    add_child(margin_container)

    _vbox_container = VBoxContainer.new()
    _vbox_container.add_theme_constant_override("separation", 10)
    margin_container.add_child(_vbox_container)

    _title_label = Label.new()
    _title_label.add_theme_font_override("font", font)
    _title_label.add_theme_font_size_override("font_size", 24)
    _title_label.text = title
    _title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    _title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    _vbox_container.add_child(_title_label)

    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

func _set_show_title(value: bool):
    show_title = value
    if !_title_label:
        await self.ready
    _title_label.visible = value

func _set_dialog_title(value: String) -> void:
    title = value
    if _title_label == null:
        await self.ready
    _title_label.text = value

func _ready() -> void:
    _build_ui()

    visible = false
    _title_label.text = title
    _title_label.visible = show_title

func show_dialog() -> void:
    if _tween:
        _tween.kill()
    _tween = get_tree().create_tween()

    visible = true
    _tween.tween_property(self, "modulate", Color.WHITE, 0.25).from(Color.TRANSPARENT).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func hide_dialog() -> void:
    if _tween:
        _tween.kill()
    _tween = get_tree().create_tween()

    _tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.25).from(Color.WHITE).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

    await _tween.finished
    visible = false
