extends CanvasLayer
class_name SxDebugTools2
## Global debug tools, take #2 (WIP)

const SCENE := preload("res://addons/sxgd/nodes/debug/SxDebugTools2/SxDebugTools2.tscn")

@onready var window := %ToolsWindow as SxDebugToolsWindow

## Setup a global instance.
static func setup_global_instance(tree: SceneTree):
    if !tree.root.has_node("SxDebugTools2"):
        tree.root.call_deferred("add_child", SCENE.instantiate())
        await tree.process_frame

## Get a global instance.
static func get_global_instance(tree: SceneTree) -> SxDebugTools2:
    return tree.root.get_node("SxDebugTools2")

func show_tools() -> void:
    $Background.visible = true
    $ToolsWindow.visible = true

func hide_tools() -> void:
    $Background.visible = false
    $ToolsWindow.visible = false

func toggle_tools() -> void:
    if $Background.visible:
        hide_tools()
    else:
        show_tools()

func _ready() -> void:
    window._tools = self
    hide_tools()

func _input(event: InputEvent):
    if event is InputEventKey:
        if event.pressed && event.physical_keycode == KEY_QUOTELEFT:
            window.toggle_console()

        if event.pressed && event.physical_keycode == KEY_F12:
            toggle_tools()

    if event is InputEventMouseButton:
        if event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
            if window._picking:
                # Get item at position
                var nodes_to_scan := get_tree().current_scene.get_children()
                while len(nodes_to_scan) > 0:
                    var node := nodes_to_scan.pop_back() as Node
                    for child in node.get_children():
                        nodes_to_scan.push_back(child)

                    if node is Sprite2D:
                        var rect = Rect2()
                        rect.position = node.global_position - (node.texture.get_size() * node.scale) / 2
                        rect.size = node.get_rect().size
                        if rect.has_point(event.global_position):
                            window.pick_node(node)
                            break

                    elif node is Control:
                        if node.get_rect().has_point(event.global_position):
                            window.pick_node(node)
                            break
