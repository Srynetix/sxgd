# A touch-compatible ItemList.
# From https://github.com/godotengine/godot-proposals/issues/2429
extends ItemList
class_name SxItemList

func _ready() -> void:
    gui_input.connect(_gui_input)

func _gui_input(event: InputEvent) -> void:
    if event is InputEventScreenDrag:
        var drag_event := event as InputEventScreenDrag
        var relative := drag_event.relative
        var scroll := get_v_scroll_bar()
        scroll.value -= relative.y / 2
