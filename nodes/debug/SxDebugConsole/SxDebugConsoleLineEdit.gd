extends SxAutocompleteLineEdit
class_name SxDebugConsoleLineEdit
## A [SxAutocompleteLineEdit] used in the [SxDebugConsole], with history commands and keyboard
## shortcuts.

## Clear screen.
signal clear_screen()

func _ready():
    super._ready()

    context_menu_enabled = false
    caret_blink = true

    focus_entered.connect(func(): SxInput.set_input_disabled(true))
    focus_exited.connect(func(): SxInput.set_input_disabled(false))

    var itemlist := get_itemlist()
    var panel := StyleBoxFlat.new()
    panel.bg_color = SxColor.with_alpha_f(Color.BLACK, 0.85)
    itemlist.add_theme_stylebox_override("panel", panel)

func _gui_input(event):
    super._gui_input(event)

    if event is InputEventKey:
        if event.pressed && event.physical_keycode == KEY_L && event.ctrl_pressed:
            clear_screen.emit()
