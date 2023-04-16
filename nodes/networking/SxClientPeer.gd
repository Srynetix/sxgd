extends Node
class_name SxClientPeer

signal connected_to_server()
signal connection_failed()
signal server_disconnected()
signal players_updated(players)

@export var use_websockets := false
@export var server_address := ""
@export var server_port := 0

var _ws_client: WebSocketMultiplayerPeer
var _players := {}
var _logger := SxLog.get_logger("SxClientPeer")
var _input_acc := 0.0
var _connected := false

# Used as cache
var _last_input_data := {}

func _init() -> void:
    name = "SxClientPeer"
    _logger.set_max_log_level(SxLog.LogLevel.DEBUG)
    if SxOs.is_web():
        # Force WebSockets on HTML5
        use_websockets = true

func _get_sync_input() -> SxSyncInput:
    return SxRpcService.get_from_tree(get_tree()).sync_input

func _get_server() -> SxServerRpc:
    return SxRpcService.get_from_tree(get_tree()).server

func _get_client() -> SxClientRpc:
    return SxRpcService.get_from_tree(get_tree()).client

func get_players() -> Dictionary:
    return _players

func _ready() -> void:
    var multiplayer_api := get_tree().get_multiplayer() as SceneMultiplayer
    multiplayer_api.peer_connected.connect(_peer_connected)
    multiplayer_api.peer_disconnected.connect(_peer_disconnected)
    multiplayer_api.connected_to_server.connect(_connected_to_server)
    multiplayer_api.connection_failed.connect(_connection_failed)
    multiplayer_api.server_disconnected.connect(_server_disconnected)
    _get_client().players_updated.connect(_players_updated)

    if use_websockets:
        _ws_client = WebSocketMultiplayerPeer.new()
        _ws_client.create_client("ws://%s:%d" % [server_address, server_port])
        multiplayer_api.multiplayer_peer = _ws_client
        multiplayer_api.allow_object_decoding = true
        _logger.debug_m("_ready", "WebSocket ClientPeer is ready, waiting for connection...")
    else:
        var peer = ENetMultiplayerPeer.new()
        peer.create_client(server_address, server_port)
        multiplayer_api.multiplayer_peer = peer
        multiplayer_api.allow_object_decoding = true
        _logger.debug_m("_ready", "ClientPeer is ready, connecting to %s:%s..." % [server_address, server_port])
    _connected = false

func _peer_connected(peer_id: int) -> void:
    _logger.debug_m("_peer_connected", "Peer '%d' connected." % peer_id)

func _peer_disconnected(peer_id: int) -> void:
    _logger.debug_m("_peer_disconnected", "Peer '%d' disconnected." % peer_id)

func _connected_to_server() -> void:
    _logger.info_m("_connected_to_server", "Connected to server.")

    _get_sync_input().create_peer_input(SxNetwork.get_nuid(self, NodePath("")))
    _get_server().ping()

    emit_signal("connected_to_server")
    _connected = true

func _connection_failed() -> void:
    _logger.info_m("_connection_failed", "Connection failed.")
    emit_signal("connection_failed")
    _connected = false

func _server_disconnected() -> void:
    _logger.error_m("_server_disconnected", "Server disconnected")
    emit_signal("server_disconnected")
    _connected = false

func _players_updated(players: Dictionary) -> void:
    _players = players
    emit_signal("players_updated", players)

func _exit_tree() -> void:
    var multiplayer_api := get_tree().get_multiplayer()
    multiplayer_api.multiplayer_peer = null

func _process(delta: float) -> void:
    if !_connected:
        return

    _input_acc += delta
    var my_input = _get_sync_input().get_current_input()
    if my_input != null:
        my_input.query_input()
        var input_data = my_input.to_json()

        # Do not send input if last computed input data is the same
        if !SxContainer.are_values_equal(_last_input_data, input_data):
            _get_server().send_input(input_data)
            _last_input_data = input_data

    if use_websockets && _connected:
        _ws_client.poll()
