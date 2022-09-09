extends Node
class_name SxClientPeer

signal connected_to_server()
signal connection_failed()
signal players_updated(players)

var server_address := ""
var server_port := 0

var _players := {}
var _logger := SxLog.get_logger("SxClientPeer")
var _input_acc := 0.0

# Used as cache
var _last_input_data := {}

func _init() -> void:
    name = "SxClientPeer"
    _logger.set_max_log_level(SxLog.LogLevel.ERROR)

func _get_sync_input() -> SxSyncInput:
    return SxRPCService.get_from_tree(get_tree()).sync_input

func _get_server() -> SxServerRPC:
    return SxRPCService.get_from_tree(get_tree()).server

func _get_client() -> SxClientRPC:
    return SxRPCService.get_from_tree(get_tree()).client

func _ready() -> void:
    get_tree().connect("network_peer_connected", self, "_peer_connected")
    get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")
    get_tree().connect("connected_to_server", self, "_connected_to_server")
    get_tree().connect("connection_failed", self, "_connection_failed")
    get_tree().connect("server_disconnected", self, "_server_disconnected")
    _get_client().connect("players_updated", self, "_players_updated")

    var peer = NetworkedMultiplayerENet.new()
    peer.create_client(server_address, server_port)
    peer.allow_object_decoding = true
    get_tree().network_peer = peer

    _logger.debug_m("_ready", "ClientPeer is ready")

func _peer_connected(peer_id: int) -> void:
    _logger.debug_m("_peer_connected", "Peer '%d' connected." % peer_id)

func _peer_disconnected(peer_id: int) -> void:
    _logger.debug_m("_peer_disconnected", "Peer '%d' disconnected." % peer_id)

func _connected_to_server() -> void:
    _logger.info_m("_connected_to_server", "Connected to server.")

    _get_sync_input().create_peer_input(SxNetwork.get_nuid(self))
    _get_server().ping()

    emit_signal("connected_to_server")

func _connection_failed() -> void:
    _logger.info_m("_connection_failed", "Connection failed.")

    emit_signal("connection_failed")

func _server_disconnected() -> void:
    _logger.error_m("_server_disconnected", "Server disconnected")
    queue_free()

func _players_updated(players: Dictionary) -> void:
    _players = players
    emit_signal("players_updated", players)

func _exit_tree() -> void:
    get_tree().network_peer = null

func _process(delta: float) -> void:
    _input_acc += delta
    var my_input = _get_sync_input().get_current_input()
    if my_input != null:
        my_input.query_input()
        var input_data = my_input.to_json()

        # Do not send input if last computed input data is the same
        if !SxContainer.are_values_equal(_last_input_data, input_data):
            _get_server().send_input(input_data)
            _last_input_data = input_data
