extends Node
class_name SxListenServerPeer

export var server_port := 0
export var max_players := 0
export var use_websockets := false

var _logger := SxLog.get_logger("SxListenServerPeer")
var _scene_tree: SceneTree
var _server: SxServerPeer

func _init() -> void:
    name = "SxListenServerPeer"
    _logger.set_max_log_level(SxLog.LogLevel.DEBUG)

func get_server_root() -> Node:
    return _scene_tree.root

func get_server_tree() -> SceneTree:
    return _scene_tree

func get_server() -> SxServerPeer:
    return _server

func _ready() -> void:
    _scene_tree = SceneTree.new()
    _scene_tree.init()

    var root := _scene_tree.root
    root.render_target_update_mode = Viewport.UPDATE_DISABLED

    var _rpc = SxRPCService.new()
    _rpc.name = "MainRPCService"
    root.add_child(_rpc)

    _server = SxServerPeer.new()
    _server.use_websockets = use_websockets
    _server.server_port = server_port
    _server.max_players = max_players
    _server.rpc_service = _rpc
    root.add_child(_server)

    _logger.debug_m("_ready", "Listen server is ready.")

func _process(delta: float) -> void:
    _scene_tree.idle(delta)

func _physics_process(delta: float) -> void:
    _scene_tree.iteration(delta)

func _input(event: InputEvent) -> void:
    _scene_tree.input_event(event)

func _exit_tree() -> void:
    _scene_tree.finish()
    _logger.debug_m("_exit_tree", "Listen server exited.")

func _notification(what: int):
    if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
        _server.set_quit_status(true)
