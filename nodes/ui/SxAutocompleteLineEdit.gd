extends LineEdit
class_name SxAutocompleteLineEdit

class AutocompletionItem:
    extends RefCounted

    var text: String
    var help: String

    func _init(text_: String, help_: String = "") -> void:
        text = text_
        help = help_

## On history up.
signal history_up()
## On history down.
signal history_down()

@export var max_completion_items := 8

var autocomplete_func: Callable

var _autocomplete_enabled := false : set = _set_autocomplete_enabled
var _itemlist: ItemList

func _ready() -> void:
    _itemlist = ItemList.new()
    _itemlist.visible = false
    _itemlist.set_anchors_and_offsets_preset(PRESET_FULL_RECT)
    _itemlist.add_theme_font_override("font", get_theme_font("font"))
    _itemlist.add_theme_font_size_override("font_size", get_theme_font_size("font_size"))
    _itemlist.allow_search = false
    _itemlist.text_overrun_behavior = TextServer.OVERRUN_TRIM_WORD_ELLIPSIS
    add_child(_itemlist)

    var scrollbar := _itemlist.get_v_scroll_bar()
    var style := StyleBoxEmpty.new()
    scrollbar.add_theme_stylebox_override("scroll", style)

    focus_exited.connect(func():
        await get_tree().process_frame
        if !_itemlist.has_focus():
            _autocomplete_enabled = false
    )

    text_changed.connect(func(_changed):
        _check_for_autocompletion()
    )

    _itemlist.item_selected.connect(func(index):
        _choose_completion(index)
    )

func get_itemlist() -> ItemList:
    return _itemlist

func _gui_input(event):
    if event is InputEventKey:
        if event.pressed && event.physical_keycode == KEY_UP:
            if _autocomplete_enabled:
                _select_previous_autocomplete_item()
            else:
                emit_signal("history_up")
            accept_event()

        elif event.pressed && event.physical_keycode == KEY_DOWN:
            if _autocomplete_enabled:
                _select_next_autocomplete_item()
            else:
                emit_signal("history_down")
            accept_event()

        elif event.pressed && event.physical_keycode == KEY_ENTER:
            if _autocomplete_enabled:
                var items := _itemlist.get_selected_items()
                if len(items) == 1:
                    _choose_completion(items[0])
                    accept_event()
                else:
                    _autocomplete_enabled = false
            else:
                _autocomplete_enabled = false

        elif event.pressed && event.physical_keycode == KEY_TAB:
            if _autocomplete_enabled:
                if _itemlist.item_count == 1:
                    _choose_completion(0)
                else:
                    _select_next_autocomplete_item()
            else:
                _check_for_autocompletion()
            accept_event()

        elif event.pressed && event.physical_keycode == KEY_ESCAPE:
            if _autocomplete_enabled:
                _autocomplete_enabled = false
                accept_event()

func _set_autocomplete_enabled(value: bool) -> void:
    _autocomplete_enabled = value
    if value:
        _itemlist.visible = true
    else:
        _itemlist.visible = false

func _choose_completion(index: int) -> void:
    var split_text := text.split(" ")
    split_text[-1] = _itemlist.get_item_text(index).split(" ")[0]

    text = " ".join(split_text)
    caret_column = len(text)

    _autocomplete_enabled = false

    grab_focus()

func _select_autocomplete_item(index: int) -> void:
    # Set item, and adapt scroll
    if _itemlist.item_count == 0:
        return

    var idx = posmod(index, _itemlist.item_count)
    _itemlist.select(idx)

    var item_rect = _itemlist.get_item_rect(idx)
    var itemlist_height = _itemlist.size.y

    var offset = (item_rect.position.y + item_rect.size.y) - itemlist_height
    var scroll := _itemlist.get_v_scroll_bar()
    scroll.value = offset + _itemlist.get_theme_font_size("font") / 2.0 - 8

func _select_next_autocomplete_item() -> void:
    var selected := _get_selected_autocomplete_item()
    _select_autocomplete_item((selected + 1) % _itemlist.item_count)

func _select_previous_autocomplete_item() -> void:
    var selected := _get_selected_autocomplete_item()
    if selected == -1:
        selected = _itemlist.item_count
    _select_autocomplete_item(selected - 1)

func _get_selected_autocomplete_item() -> int:
    var items := _itemlist.get_selected_items()
    if len(items) == 0:
        return -1
    else:
        return items[0]

func _update_autocomplete_items(items: Array[AutocompletionItem]) -> void:
    _itemlist.clear()

    for item in items:
        var item_text := item.text
        if item.help:
            item_text += " [%s]" % item.help
        _itemlist.add_item(item_text)

    # Wait for the item generation
    await get_tree().process_frame

    # Set size depending on item count
    _itemlist.size.y = min(max_completion_items, len(items)) * _itemlist.get_theme_font_size("font") + 8
    _itemlist.global_position.y = global_position.y - _itemlist.size.y

func _check_for_autocompletion() -> void:
    if !has_focus():
        _autocomplete_enabled = false
        return

    var split_text := text.split(" ")
    if autocomplete_func.is_null():
        _autocomplete_enabled = false
        return

    var autocompletion_items := autocomplete_func.call(split_text, len(split_text) - 1) as Array[AutocompletionItem]
    var filtered_items := [] as Array[AutocompletionItem]

    for item in autocompletion_items:
        if item.text.begins_with(split_text[-1]):
            filtered_items.push_back(item)

    if len(filtered_items) > 0:
        _autocomplete_enabled = true
        _update_autocomplete_items(filtered_items)
    else:
        _autocomplete_enabled = false
