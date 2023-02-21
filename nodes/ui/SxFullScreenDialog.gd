tool
extends Panel
class_name SxFullScreenDialog

const FONT_DATA = preload("res://addons/sxgd/assets/fonts/Jost-800-Heavy.ttf")

export var title := "Dialog title" setget _set_dialog_title
export var autohide := true
export var show_title := true setget _set_show_title

var _title_label: Label
var _vbox_container: VBoxContainer

func _build_ui() -> void:
    var font := DynamicFont.new()
    font.size = 24
    font.use_mipmaps = true
    font.use_filter = true
    font.font_data = FONT_DATA

    var margin_container := MarginContainer.new()
    margin_container.name = "MarginContainer"
    margin_container.set_anchors_and_margins_preset(Control.PRESET_WIDE)
    SxUi.set_margin_container_margins(margin_container, 20)
    add_child(margin_container)

    _vbox_container = VBoxContainer.new()
    _vbox_container.set("custom_constants/separation", 10)
    margin_container.add_child(_vbox_container)

    _title_label = Label.new()
    _title_label.set("custom_fonts/font", font)
    _title_label.text = title
    _title_label.align = Label.ALIGN_CENTER
    _title_label.valign = Label.VALIGN_CENTER
    _vbox_container.add_child(_title_label)

    set_anchors_and_margins_preset(Control.PRESET_WIDE)

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
    _build_ui()

    visible = false
    _title_label.text = title
    _title_label.visible = show_title

func show() -> void:
    visible = true

func hide() -> void:
    visible = false
