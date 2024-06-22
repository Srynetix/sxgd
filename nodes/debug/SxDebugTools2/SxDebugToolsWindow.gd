extends Window
class_name SxDebugToolsWindow

@onready var tabs := %Tabs as TabContainer
@onready var toggle_console_btn := %ToggleConsole as Button
@onready var console := %Console as SxDebugConsole
@onready var dock_button := %DockButton as MenuButton
@onready var pick_button := %PickButton as Button

@onready var node_tree := %NodeTree as Tree
@onready var node_inspector := %NodeInspector as SxDebugNodeInspector
@onready var refresh_node_tree_button := %RefreshNodeTreeButton as Button

var _tools: SxDebugTools2
var _picking := false
var _tree_dict := {}
var _inspected_node: Node

var _node_tree_update_timer: Timer

enum DockType {
    Right = 0,
    Bottom = 1,
    Left = 2,
    FullScreen = 3
}

func _ready() -> void:
    toggle_console_btn.pressed.connect(func():
        console.visible = !console.visible
    )

    dock_button.get_popup().id_pressed.connect(func(item_id):
        _dock_tools(item_id as DockType)
    )

    close_requested.connect(func():
        _tools.hide_tools()
    )

    pick_button.pressed.connect(func():
        _picking = !_picking

        if _picking:
            Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
        else:
            Input.set_default_cursor_shape(Input.CURSOR_ARROW)
    )

    node_tree.item_selected.connect(func():
        var selected := node_tree.get_selected()
        var node := selected.get_metadata(0)
        if is_instance_valid(node):
            _set_node_to_inspect(selected.get_metadata(0))
    )

    _dock_tools(DockType.Right)
    _update_node_tree()

    refresh_node_tree_button.pressed.connect(func():
        _update_node_tree()
    )


func pick_node(node: Node):
    _picking = false
    _set_node_to_inspect(node)

func toggle_console():
    if !visible:
        _tools.show_tools()
        console.visible = true
    else:
        console.visible = !console.visible

    if console.visible:
        console.focus_input()

func _set_node_to_inspect(node: Node):
    if is_instance_valid(node):
        node_inspector.inspected_node = node

func _dock_tools(dock_type: DockType) -> void:
    var vp_size = get_tree().root.get_viewport().get_visible_rect().size
    var window_size = get_size_with_decorations()
    var min_width := 400
    var min_height := 400
    var border_size := 8
    var title_bar_size := 32

    if dock_type == DockType.Right:
        size.x = min_width - border_size
        size.y = vp_size.y - title_bar_size - border_size
        position.x = vp_size.x - size.x - border_size
        position.y = title_bar_size
    elif dock_type == DockType.Left:
        size.x = min_width - border_size
        size.y = vp_size.y - title_bar_size - border_size
        position.x = border_size
        position.y = title_bar_size
    elif dock_type == DockType.Bottom:
        size.x = vp_size.x - border_size * 2
        size.y = min_height
        position.x = border_size
        position.y = vp_size.y - size.y - border_size
    elif dock_type == DockType.FullScreen:
        size.x = vp_size.x
        size.y = vp_size.y
        position.x = 0
        position.y = 0

func _update_node_tree() -> void:
    node_tree.clear()

    var current_scene := get_tree().current_scene
    var root = node_tree.create_item()
    _create_node_tree_at_root(root, current_scene)

func _create_node_tree_at_root(tree_root: TreeItem, root: Node) -> void:
    tree_root.set_text(0, root.name)
    tree_root.set_metadata(0, root)

    for child in root.get_children():
        var tree_node := tree_root.create_child()
        _create_node_tree_at_root(tree_node, child)

func _input(event: InputEvent):
    if event is InputEventKey:
        if event.pressed && event.physical_keycode == KEY_QUOTELEFT:
            toggle_console()

        if event.pressed && event.physical_keycode == KEY_F12:
            _tools.toggle_tools()
