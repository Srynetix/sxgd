extends LineEdit
class_name SxDebugConsoleLineEdit
## [LineEdit] used in the [SxDebugConsole], with history commands.

## On history up.
signal history_up()
## On history down.
signal history_down()

func _ready():
    context_menu_enabled = false
    caret_blink = true

    focus_entered.connect(func(): SxInput.set_input_disabled(true))
    focus_exited.connect(func(): SxInput.set_input_disabled(false))

func _gui_input(event):
    if event is InputEventKey:
        if event.pressed && event.physical_keycode == KEY_UP:
            emit_signal("history_up")
            accept_event()
        elif event.pressed && event.physical_keycode == KEY_DOWN:
            emit_signal("history_down")
            accept_event()
