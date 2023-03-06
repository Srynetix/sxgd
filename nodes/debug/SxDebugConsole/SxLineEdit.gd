extends LineEdit
class_name SxLineEdit

signal history_up()
signal history_down()

func _gui_input(event):
    if event is InputEventKey:
        if event.pressed && event.physical_scancode == KEY_UP:
            emit_signal("history_up")
        elif event.pressed && event.physical_scancode == KEY_DOWN:
            emit_signal("history_down")