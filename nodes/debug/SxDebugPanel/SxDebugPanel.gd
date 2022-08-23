# Global debug panel, displaying debug info and logs.
extends CanvasLayer
class_name SxDebugPanel

# Panel type to display.
enum PanelType {
    DEBUG_INFO,
    LOG,
    NODE_TRACER,
}

# Should the panel be visible on startup?
export var visible_on_startup := false

onready var main_panel := $Panel as Panel
onready var log_panel := $Panel/HBoxContainer/Container/SxLogPanel as SxLogPanel
onready var node_tracer := $Panel/HBoxContainer/Container/NodeTracerSystem as SxNodeTracerSystem
onready var debug_info := $Panel/SxDebugInfo as SxDebugInfo
onready var _visible := visible_on_startup

var _current_panel := PanelType.DEBUG_INFO as int

func _ready():
    debug_info.set_visibility(false)
    main_panel.visible = false
    node_tracer.visible = false
    log_panel.visible = false

    if visible_on_startup:
        show_panel()

# Hide the debug panel.
func hide_panel() -> void:
    _hide_panels()
    main_panel.visible = false
    _visible = false

# Show the debug panel.
func show_panel() -> void:
    main_panel.visible = true
    _visible = true
    _show_panel(_current_panel)

# Toggle the debug panel.
func toggle_panel() -> void:
    if _visible:
        hide_panel()
    else:
        show_panel()

func _show_panel(panel_type: int) -> void:
    _current_panel = panel_type
    _hide_panels()

    match panel_type:
        PanelType.DEBUG_INFO:
            debug_info.set_visibility(true)
        PanelType.LOG:
            log_panel.visible = true
        PanelType.NODE_TRACER:
            node_tracer.visible = true

func _hide_panels() -> void:
    debug_info.set_visibility(false)
    log_panel.visible = false
    node_tracer.visible = false

func _input(event: InputEvent):
    if event is InputEventKey:
        if event.pressed && event.scancode == KEY_F12:
            toggle_panel()

        elif event.pressed && event.scancode == KEY_F9 && _visible:
            _show_panel(PanelType.NODE_TRACER)

        elif event.pressed && event.scancode == KEY_F10 && _visible:
            _show_panel(PanelType.LOG)

        elif event.pressed && event.scancode == KEY_F11 && _visible:
            _show_panel(PanelType.DEBUG_INFO)

        elif event.pressed && event.scancode == KEY_F5 && _visible:
            get_tree().reload_current_scene()

        elif event.pressed && event.scancode == KEY_F2 && _visible:
            get_tree().paused = !get_tree().paused
