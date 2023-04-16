extends Node
class_name SxListenServerPeer

@export var server_port := 0
@export var max_players := 0
@export var use_websockets := false

var _logger := SxLog.get_logger("SxListenServerPeer")
var _server: SxServerPeer

func _init() -> void:
    name = "SxListenServerPeer"
    _logger.set_max_log_level(SxLog.LogLevel.DEBUG)

func get_server_root() -> Node:
    return self

func get_server() -> SxServerPeer:
    return _server

func _ready() -> void:
    var root := self

    var multiplayer_api = SceneMultiplayer.create_default_interface()
    get_tree().set_multiplayer(multiplayer_api, get_path())

    var _rpc = SxRpcService.new()
    _rpc.multiplayer_node_path = get_path()
    _rpc.name = "MainRpcService"
    root.add_child(_rpc)

    _server = SxServerPeer.new()
    _server.use_websockets = use_websockets
    _server.server_port = server_port
    _server.max_players = max_players
    _server.rpc_service = _rpc
    _server.multiplayer_node_path = get_path()
    root.add_child(_server)

    _logger.debug_m("_ready", "Listen server is ready.")

func _exit_tree() -> void:
    _logger.debug_m("_exit_tree", "Listen server exited.")

func _notification(what: int):
    if what == NOTIFICATION_WM_CLOSE_REQUEST:
        _server.set_quit_status(true)
