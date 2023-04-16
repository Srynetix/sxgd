extends SxFullScreenDialog
class_name SxFullScreenFileDialog

signal cancelled()
signal file_selected(file)

signal _item_doubleclicked(file)

class PathShortcut:
    var name: String
    var path: String

    func _init(name_: String, path_: String):
        name = name_
        path = path_

    static func from_dict(d: Dictionary) -> PathShortcut:
        return PathShortcut.new(d["name"], d["path"])

enum Mode {
    OPEN_FILE = 0,
    SAVE_FILE = 1
}

const light_font := preload("res://addons/sxgd/assets/fonts/Jost-400-Book.ttf")
const code_font := preload("res://addons/sxgd/assets/fonts/OfficeCodePro-Regular.otf")

@export var mode := Mode.OPEN_FILE
@export var shortcuts := [] as Array[Dictionary]
@export var file_filter := ""

var _doubletap: SxDoubleTap
var _confirmation: SxFullScreenConfirmationDialog
var _current_path_lineedit: LineEdit
var _go_up_btn: SxFaButton
var _shortcuts_list: SxItemList
var _files_list: SxItemList
var _filename_lbl: LineEdit
var _cancel_btn: Button
var _validate_btn: Button

var _filters := []
var _shortcuts := []
var _current_files := []
var _current_path := "" : set = _set_current_path
var _file_selected := ""
var _open_delayer: Timer

func _build_ui_file() -> void:
    _doubletap = SxDoubleTap.new()
    _doubletap.should_process_input = false
    add_child(_doubletap)

    _confirmation = SxFullScreenConfirmationDialog.new()
    add_child(_confirmation)

    var buttons := HBoxContainer.new()
    buttons.add_theme_constant_override("separation", 10)
    buttons.alignment = HBoxContainer.ALIGNMENT_END
    _vbox_container.add_child(buttons)

    _current_path_lineedit = LineEdit.new()
    _current_path_lineedit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    _current_path_lineedit.add_theme_font_override("font", light_font)
    _current_path_lineedit.add_theme_font_size_override("font_size", 24)
    _current_path_lineedit.text = "user://"
    _current_path_lineedit.editable = false
    buttons.add_child(_current_path_lineedit)

    _go_up_btn = SxFaButton.new()
    _go_up_btn.icon_name = "arrow-up"
    buttons.add_child(_go_up_btn)

    var hbox_container := HBoxContainer.new()
    hbox_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
    hbox_container.add_theme_constant_override("separation", 20)
    _vbox_container.add_child(hbox_container)

    _shortcuts_list = SxItemList.new()
    _shortcuts_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    _shortcuts_list.size_flags_stretch_ratio = 0.5
    _shortcuts_list.add_theme_font_override("font", code_font)
    _shortcuts_list.add_theme_font_size_override("font_size", 24)
    hbox_container.add_child(_shortcuts_list)

    _files_list = SxItemList.new()
    _files_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    _files_list.add_theme_font_override("font", code_font)
    _files_list.add_theme_font_size_override("font_size", 24)
    hbox_container.add_child(_files_list)

    var hbox_container2 := HBoxContainer.new()
    hbox_container2.add_theme_constant_override("separation", 10)
    hbox_container2.alignment = HBoxContainer.ALIGNMENT_END
    _vbox_container.add_child(hbox_container2)

    _filename_lbl = LineEdit.new()
    _filename_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    _filename_lbl.add_theme_font_override("font", light_font)
    _filename_lbl.add_theme_font_size_override("font_size", 24)
    hbox_container2.add_child(_filename_lbl)

    _cancel_btn = Button.new()
    _cancel_btn.add_theme_font_override("font", light_font)
    _cancel_btn.add_theme_font_size_override("font_size", 24)
    _cancel_btn.text = "Cancel"
    hbox_container2.add_child(_cancel_btn)

    _validate_btn = Button.new()
    _validate_btn.add_theme_font_override("font", light_font)
    _validate_btn.add_theme_font_size_override("font_size", 24)
    _validate_btn.text = "Open"
    hbox_container2.add_child(_validate_btn)

func _ready() -> void:
    super._ready()
    _build_ui_file()

    visible = false
    _set_dialog_title("Choose file ...")

    _shortcuts_list.item_selected.connect(_select_shortcut)
    _files_list.gui_input.connect(_on_files_input)
    _files_list.item_selected.connect(_select_file)
    _filename_lbl.text_changed.connect(_filename_changed)
    _go_up_btn.pressed.connect(_go_up)
    _cancel_btn.pressed.connect(_cancel)
    _validate_btn.pressed.connect(_validate)
    _confirmation.confirmed.connect(_validate_confirmation)
    _item_doubleclicked.connect(_on_file_doubleclick)

    _open_delayer = Timer.new()
    _open_delayer.wait_time = 0.25
    _open_delayer.one_shot = true
    _open_delayer.autostart = false
    add_child(_open_delayer)

    _filters = SxArray.trim_strings(file_filter.split(","))

    match mode:
        Mode.OPEN_FILE:
            _validate_btn.text = "Open"
        Mode.SAVE_FILE:
            _validate_btn.text = "Save"

    for item in shortcuts:
        var sc := PathShortcut.from_dict(item)
        _shortcuts.append(sc)

    _shortcuts_list.clear()
    for item in _shortcuts:
        var sc := item as PathShortcut
        _shortcuts_list.add_item(sc.name)

    invalidate()

func invalidate() -> void:
    if _shortcuts_list.item_count > 0:
        _shortcuts_list.select(0)
        _select_shortcut(0)
    _file_selected = ""
    _validate_btn.disabled = true

func _set_selected_file(file: SxOs.DirOrFile) -> void:
    _file_selected = file.path
    _validate_btn.disabled = false
    _filename_lbl.text = file.name

func _reset_selected_file() -> void:
    _file_selected = ""
    _validate_btn.disabled = true
    _filename_lbl.text = ""

func _cancel() -> void:
    emit_signal("cancelled")
    if autohide:
        hide_dialog()

func _validate() -> void:
    if mode == Mode.SAVE_FILE:
        if FileAccess.file_exists(_file_selected):
            _confirmation.message = "Are you sure you want to overwrite the file %s?" % _file_selected
            _confirmation.fade_in()
            return

    _validate_confirmation()

func _validate_confirmation() -> void:
    emit_signal("file_selected", _file_selected)
    if autohide:
        hide_dialog()

func _on_files_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        var btn_event := event as InputEventMouseButton
        if btn_event.double_click:
            _handle_directory_open(_files_list.get_item_at_position(btn_event.position))
            return

    var doubletap_data := _doubletap.process_doubletap(event)
    if doubletap_data.result:
        _handle_directory_open(_files_list.get_item_at_position(doubletap_data.position))

func _handle_directory_open(item_id: int) -> void:
    # The open_delayer is used to prevent fast doubletaps with a mouse
    if !_open_delayer.is_stopped() || item_id == -1:
        return

    _open_delayer.start()
    emit_signal(_item_doubleclicked.get_name(), _current_files[item_id])

func _on_file_doubleclick(item: SxOs.DirOrFile):
    if item.is_directory():
        _set_current_path(item.path)
    else:
        _set_selected_file(item)
        _validate()

func _select_shortcut(item_id: int) -> void:
    var sc := _shortcuts[item_id] as PathShortcut
    _set_current_path(sc.path)

func _go_up() -> void:
    if _current_path.ends_with("://"):
        return
    _set_current_path(_current_path.get_base_dir())

func _select_file(item_id: int) -> void:
    var file := _current_files[item_id] as SxOs.DirOrFile
    if file.is_directory():
        _reset_selected_file()
    else:
        _set_selected_file(file)

func _filename_changed(value: String) -> void:
    if mode == Mode.SAVE_FILE:
        var is_valid := false
        if len(value.strip_edges()) > 0:
            if len(_filters) > 0:
                for filter in _filters:
                    is_valid = is_valid || value.match(filter)
            else:
                is_valid = true

            if is_valid:
                _file_selected = "%s/%s" % [_current_path, value]
                _validate_btn.disabled = false
            else:
                _file_selected = ""
                _validate_btn.disabled = true

func _update_files() -> void:
    var files := SxOs.list_files_in_directory(_current_path, _filters)
    _files_list.clear()
    _current_files = []

    for file in files:
        _current_files.append(file)
        if file.type == SxOs.DirOrFile.Type.DIRECTORY:
            _files_list.add_item(file.name + "/")
        else:
            _files_list.add_item(file.name)

    _reset_selected_file()

func _set_current_path(value: String) -> void:
    _current_path = value
    _current_path_lineedit.text = value
    _update_files()
