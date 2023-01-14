# Global debug tools, displaying debug info and logs.
extends CanvasLayer
class_name SxDebugTools

const NORMAL_FONT_DATA = preload("res://addons/sxgd/assets/fonts/OfficeCodePro-Regular.otf")
const BOLD_FONT_DATA = preload("res://addons/sxgd/assets/fonts/OfficeCodePro-Bold.otf")
const CODE_FONT_DATA = preload("res://addons/sxgd/assets/fonts/Inconsolata-Regular.ttf")

# Panel type to display.
enum PanelType {
    DEBUG_INFO,
    LOG,
    NODE_TRACER,
    SCENE_TREE_DUMP,
}

# Should the panel be visible on startup?
export var visible_on_startup := false

onready var _visible := visible_on_startup

var _main_panel: Panel
var _log_panel: SxLogPanel
var _node_tracer: SxNodeTracerSystem
var _scene_tree_dump: MarginContainer
var _debug_info: SxDebugInfo
var _current_panel := PanelType.DEBUG_INFO as int

func _build_ui() -> void:
    var bold_font := DynamicFont.new()
    bold_font.use_mipmaps = true
    bold_font.use_filter = true
    bold_font.font_data = BOLD_FONT_DATA

    var code_font := DynamicFont.new()
    code_font.size = 13
    code_font.outline_size = 1
    code_font.outline_color = Color.black
    code_font.use_mipmaps = true
    code_font.use_filter = true
    code_font.font_data = CODE_FONT_DATA

    var normal_font := DynamicFont.new()
    normal_font.size = 12
    normal_font.outline_size = 1
    normal_font.outline_color = Color.black
    normal_font.use_mipmaps = true
    normal_font.use_filter = true
    normal_font.font_data = NORMAL_FONT_DATA

    var box := StyleBoxEmpty.new()

    layer = 4

    _main_panel = Panel.new()
    _main_panel.name = "Panel"
    _main_panel.self_modulate = Color(0, 0, 0, 0.58)
    _main_panel.anchor_right = 1.0
    _main_panel.anchor_bottom = 1.0
    _main_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(_main_panel)

    _debug_info = SxDebugInfo.new()
    _main_panel.add_child(_debug_info)

    var hbox_container := HBoxContainer.new()
    hbox_container.name = "HBox"
    hbox_container.anchor_right = 1.0
    hbox_container.anchor_bottom = 1.0
    hbox_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
    _main_panel.add_child(hbox_container)

    var container := Control.new()
    hbox_container.name = "Main"
    container.mouse_filter = Control.MOUSE_FILTER_IGNORE
    container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    hbox_container.add_child(container)

    _log_panel = SxLogPanel.new()
    container.add_child(_log_panel)

    _node_tracer = SxNodeTracerSystem.new()
    container.add_child(_node_tracer)

    _scene_tree_dump = MarginContainer.new()
    _scene_tree_dump.name = "SceneTreeDumpContainer"
    _scene_tree_dump.anchor_right = 1.0
    _scene_tree_dump.anchor_bottom = 1.0
    _scene_tree_dump.set("custom_constants/margin_right", 20)
    _scene_tree_dump.set("custom_constants/margin_top", 20)
    _scene_tree_dump.set("custom_constants/margin_left", 20)
    _scene_tree_dump.set("custom_constants/margin_bottom", 20)
    container.add_child(_scene_tree_dump)

    var scene_tree_hbox_container := HBoxContainer.new()
    scene_tree_hbox_container.name = "HBox"
    _scene_tree_dump.add_child(scene_tree_hbox_container)

    var local_scene_tree_container := VBoxContainer.new()
    local_scene_tree_container.name = "LocalTreeContainer"
    local_scene_tree_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    local_scene_tree_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
    scene_tree_hbox_container.add_child(local_scene_tree_container)

    var local_scene_tree_title := Label.new()
    local_scene_tree_title.name = "Title"
    local_scene_tree_title.set("custom_fonts/font", bold_font)
    local_scene_tree_title.text = "Local tree"
    local_scene_tree_container.add_child(local_scene_tree_title)

    var local_scene_tree := Tree.new()
    local_scene_tree.name = "Tree"
    local_scene_tree.size_flags_vertical = Control.SIZE_EXPAND_FILL
    local_scene_tree.set("custom_constants/draw_guides", 0)
    local_scene_tree.set("custom_constants/draw_relationship_lines", 1)
    local_scene_tree.set("custom_fonts/font", code_font)
    local_scene_tree.set("custom_styles/bg", box)
    local_scene_tree_container.add_child(local_scene_tree)

    var listenserver_scene_tree_container := VBoxContainer.new()
    listenserver_scene_tree_container.name = "ListenServerTreeContainer"
    listenserver_scene_tree_container.visible = false
    listenserver_scene_tree_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    listenserver_scene_tree_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
    scene_tree_hbox_container.add_child(listenserver_scene_tree_container)

    var listenserver_scene_tree_title := Label.new()
    listenserver_scene_tree_title.name = "Title"
    listenserver_scene_tree_title.set("custom_fonts/font", bold_font)
    listenserver_scene_tree_title.text = "Listen server tree"
    listenserver_scene_tree_container.add_child(listenserver_scene_tree_title)

    var listenserver_scene_tree := Tree.new()
    listenserver_scene_tree.name = "Tree"
    listenserver_scene_tree.size_flags_vertical = Control.SIZE_EXPAND_FILL
    listenserver_scene_tree.set("custom_constants/draw_guides", 0)
    listenserver_scene_tree.set("custom_constants/draw_relationship_lines", 1)
    listenserver_scene_tree.set("custom_fonts/font", code_font)
    listenserver_scene_tree.set("custom_styles/bg", box)
    listenserver_scene_tree_container.add_child(listenserver_scene_tree)

    var right_container := MarginContainer.new()
    right_container.name = "RightContainer"
    right_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
    right_container.set("custom_constants/margin_right", 10)
    right_container.set("custom_constants/margin_top", 10)
    right_container.set("custom_constants/margin_left", 10)
    right_container.set("custom_constants/margin_bottom", 10)
    hbox_container.add_child(right_container)

    var right_title := Label.new()
    right_title.name = "Title"
    right_title.size_flags_horizontal = Control.SIZE_SHRINK_END
    right_title.size_flags_vertical = 0
    right_title.set("custom_fonts/font", bold_font)
    right_title.text = "Debug Tools™"
    right_container.add_child(right_title)

    var right_label := Label.new()
    right_label.name = "Instructions"
    right_label.size_flags_horizontal = Control.SIZE_SHRINK_END
    right_label.size_flags_vertical = Control.SIZE_SHRINK_END
    right_label.set("custom_fonts/font", normal_font)
    right_label.text = (
        "F7 - Show scene tree dumps\n"
        + "F9 - Show node traces\n"
        + "F10 - Show logs\n"
        + "F11 - Show stats\n"
        + "F12 - Toggle panel"
    )
    right_container.add_child(right_label)

func _ready() -> void:
    _build_ui()

    _debug_info.set_visibility(false)
    _main_panel.visible = false
    _node_tracer.visible = false
    _log_panel.visible = false
    _scene_tree_dump.visible = false

    if visible_on_startup:
        show()

# Hide the debug panel.
func hide() -> void:
    _hide_panels()
    _main_panel.visible = false
    _visible = false

# Show the debug panel.
func show() -> void:
    _main_panel.visible = true
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
            _debug_info.set_visibility(true)
        PanelType.LOG:
            _log_panel.visible = true
        PanelType.NODE_TRACER:
            _node_tracer.visible = true
        PanelType.SCENE_TREE_DUMP:
            _show_scene_tree_dump()

func _show_scene_tree_dump() -> void:
    _scene_tree_dump.visible = true
    var local_tree := _scene_tree_dump.get_node("HBox/LocalTreeContainer/Tree") as Tree
    var ls_tree := _scene_tree_dump.get_node("HBox/ListenServerTreeContainer/Tree") as Tree
    var ls_container := _scene_tree_dump.get_node("HBox/ListenServerTreeContainer") as VBoxContainer
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
    _debug_info.set_visibility(false)
    _log_panel.visible = false
    _node_tracer.visible = false
    _scene_tree_dump.visible = false

func _input(event: InputEvent):
    if event is InputEventKey:
        if event.pressed && event.scancode == KEY_F12:
            toggle()

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
