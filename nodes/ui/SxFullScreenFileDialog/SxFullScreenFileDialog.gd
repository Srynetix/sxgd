extends SxFullScreenDialog
class_name SxFullScreenFileDialog

signal cancel()
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

export(Mode) var mode := Mode.OPEN_FILE
export(Array, Dictionary) var shortcuts := []
export var file_filter := ""

onready var _doubletap := $SxDoubleTap as SxDoubleTap
onready var _shortcuts_list := $MarginContainer/VBoxContainer/HBoxContainer/Shortcuts as SxItemList
onready var _files_list := $MarginContainer/VBoxContainer/HBoxContainer/Files as SxItemList
onready var _current_path_lineedit := $MarginContainer/VBoxContainer/Buttons/CurrentPath as LineEdit
onready var _go_up_btn := $MarginContainer/VBoxContainer/Buttons/GoUp as SxFAButton
onready var _filename_lbl := $MarginContainer/VBoxContainer/HBoxContainer2/FileName as LineEdit
onready var _cancel_btn := $MarginContainer/VBoxContainer/HBoxContainer2/Cancel as Button
onready var _validate_btn := $MarginContainer/VBoxContainer/HBoxContainer2/Validate as Button
onready var _confirmation := $Confirmation as FullScreenConfirmationDialog

var _filters := []
var _shortcuts := []
var _current_files := []
var _current_path := "" setget _set_current_path
var _file_selected := ""

func _ready() -> void:
    _shortcuts_list.connect("item_selected", self, "_select_shortcut")
    _files_list.connect("gui_input", self, "_on_files_input")
    _files_list.connect("item_selected", self, "_select_file")
    _filename_lbl.connect("text_changed", self, "_filename_changed")
    _go_up_btn.connect("pressed", self, "_go_up")
    _cancel_btn.connect("pressed", self, "_cancel")
    _validate_btn.connect("pressed", self, "_validate")
    _confirmation.connect("confirmed", self, "_validate_confirmation")
    connect("_item_doubleclicked", self, "_on_file_doubleclick")

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
    if len(_shortcuts_list.items) > 0:
        _shortcuts_list.select(0)
        _select_shortcut(0)
    _file_selected = ""
    _validate_btn.disabled = true

func _set_selected_file(file: SxOS.DirOrFile) -> void:
    _file_selected = file.path
    _validate_btn.disabled = false
    _filename_lbl.text = file.name

func _reset_selected_file() -> void:
    _file_selected = ""
    _validate_btn.disabled = true
    _filename_lbl.text = ""

func _cancel() -> void:
    emit_signal("cancel")
    if autohide:
        hide()

func _validate() -> void:
    if mode == Mode.SAVE_FILE:
        var f = File.new()
        if f.file_exists(_file_selected):
            _confirmation.message = "Are you sure you want to overwrite the file %s?" % _file_selected
            _confirmation.fade_in()
            return

    _validate_confirmation()

func _validate_confirmation() -> void:
    emit_signal("file_selected", _file_selected)
    if autohide:
        hide()

func _on_files_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        var btn_event := event as InputEventMouseButton
        if btn_event.doubleclick:
            _handle_directory_open(_files_list.get_item_at_position(btn_event.position))
            return

    var doubletap_data = _doubletap.process_doubletap(event)
    if doubletap_data.result:
        _handle_directory_open(_files_list.get_item_at_position(doubletap_data.position))

func _handle_directory_open(item_id: int) -> void:
    if item_id == -1:
        return
    emit_signal("_item_doubleclicked", _current_files[item_id])

func _on_file_doubleclick(item: SxOS.DirOrFile):
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
    var file := _current_files[item_id] as SxOS.DirOrFile
    if file.is_directory():
        _reset_selected_file()
    else:
        _set_selected_file(file)

func _filename_changed(value: String) -> void:
    if mode == Mode.SAVE_FILE:
        var is_valid = false
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
    var files = SxOS.list_files_in_directory(_current_path, _filters)
    _files_list.clear()
    _current_files = []

    for file in files:
        _current_files.append(file)
        if file.type == SxOS.DirOrFile.Type.DIRECTORY:
            _files_list.add_item(file.name + "/")
        else:
            _files_list.add_item(file.name)

    _reset_selected_file()

func _set_current_path(value: String) -> void:
    _current_path = value
    _current_path_lineedit.text = value
    _update_files()
