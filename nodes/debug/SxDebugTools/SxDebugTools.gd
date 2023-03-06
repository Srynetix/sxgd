# Global debug tools, displaying debug info and logs.
extends CanvasLayer
class_name SxDebugTools

# Panel type to display.
enum PanelType {
    DEBUG_INFO,
    LOG,
    NODE_TRACER,
    SCENE_TREE_DUMP,
    CONSOLE,
}

# Should the panel be visible on startup?
export var visible_on_startup := false
export(PanelType) var panel_on_startup := PanelType.DEBUG_INFO

onready var main_panel := $Panel as Panel
onready var log_panel := $Panel/HBoxContainer/Container/SxLogPanel as SxLogPanel
onready var node_tracer := $Panel/HBoxContainer/Container/NodeTracerSystem as SxNodeTracerSystem
onready var scene_tree_dump := $Panel/HBoxContainer/Container/SceneTreeDump as MarginContainer
onready var debug_console := $Panel/HBoxContainer/Container/DebugConsole as SxDebugConsole
onready var debug_info := $Panel/SxDebugInfo as SxDebugInfo
onready var _visible := visible_on_startup
onready var _current_panel := panel_on_startup as int

var _previous_mouse_mode = Input.MOUSE_MODE_VISIBLE

func _ready():
    debug_info.set_visibility(false)
    main_panel.visible = false
    node_tracer.visible = false
    log_panel.visible = false
    scene_tree_dump.visible = false
    debug_console.visible = false

    if visible_on_startup:
        show()

# Hide the debug panel.
func hide() -> void:
    _hide_panels()
    main_panel.visible = false
    _visible = false
    Input.mouse_mode = _previous_mouse_mode

# Show the debug panel.
func show() -> void:
    _previous_mouse_mode = Input.mouse_mode
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    main_panel.visible = true
    _visible = true
    _show_panel(_current_panel)

# Toggle the debug panel.
func toggle() -> void:
    if _visible:
        hide()
    else:
        show()

# Show a specific panel.
func show_specific_panel(panel_type: int) -> void:
    _show_panel(panel_type)

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
        PanelType.SCENE_TREE_DUMP:
            _show_scene_tree_dump()
        PanelType.CONSOLE:
            debug_console.visible = true

func _show_scene_tree_dump() -> void:
    scene_tree_dump.visible = true
    var local_tree := scene_tree_dump.get_node("HBoxContainer/Local/Tree") as Tree
    var ls_tree := scene_tree_dump.get_node("HBoxContainer/ListenServer/Tree") as Tree
    var ls_container := scene_tree_dump.get_node("HBoxContainer/ListenServer") as VBoxContainer
    _build_node_tree(local_tree, get_tree().root)

    # Check for a listen server
    ls_container.visible = false
    var listen_server_peer := get_tree().root.find_node("SxListenServerPeer", true, false)
    if listen_server_peer != null:
        ls_container.visible = true
        var peer := listen_server_peer as SxListenServerPeer
        var tree := peer.get_server_tree()
        _build_node_tree(ls_tree, tree.root)

func _build_node_tree(tree: Tree, node: Node) -> void:
    tree.clear()
    var root := tree.create_item()
    _build_node_tree_item(tree, root, node)

func _build_node_tree_child(tree: Tree, parent: TreeItem, node: Node) -> void:
    var item := tree.create_item(parent)
    _build_node_tree_item(tree, item, node)

func _build_node_tree_item(tree: Tree, item: TreeItem, node: Node) -> void:
    item.set_text(0, "%s (%s)" % [node.name, node.get_class()])
    for child in node.get_children():
        _build_node_tree_child(tree, item, child)

func _hide_panels() -> void:
    debug_info.set_visibility(false)
    log_panel.visible = false
    node_tracer.visible = false
    scene_tree_dump.visible = false
    debug_console.visible = false

func _input(event: InputEvent):
    if event is InputEventKey:
        if event.pressed && event.scancode == KEY_F12:
            toggle()

        elif event.pressed && event.scancode == KEY_F6 && _visible:
            _show_panel(PanelType.CONSOLE)

        elif event.pressed && event.scancode == KEY_F7 && _visible:
            _show_panel(PanelType.SCENE_TREE_DUMP)

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
