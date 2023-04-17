extends LineEdit
class_name SxDebugConsoleLineEdit

signal history_up()
signal history_down()

func _ready():
    context_menu_enabled = false
    caret_blink = true

func _gui_input(event):
    if event is InputEventKey:
        if event.pressed && event.physical_keycode == KEY_UP:
            emit_signal("history_up")
            accept_event()
        elif event.pressed && event.physical_keycode == KEY_DOWN:
            emit_signal("history_down")
            accept_event()
