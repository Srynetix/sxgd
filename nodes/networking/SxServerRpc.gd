extends Node
class_name SxServerRpc

signal player_username_updated(player_id, username)

var _logger := SxLog.get_logger("SxServerRpc")
var _service: Node  # SxRpcService

func _init() -> void:
    name = "SxServerRpc"
    _logger.set_max_log_level(SxLog.LogLevel.DEBUG)

func link_service(service: Node) -> void:
    _service = service

func _get_client():
    return _service.client

func _get_sync_input() -> SxSyncInput:
    return _service.sync_input as SxSyncInput

func ping() -> void:
    var my_id = SxNetwork.get_nuid(self)
    _logger.debug_mn(my_id, "ping", "Sending ping to server.")
    rpc_id(1, "_ping")

func send_input(input: Dictionary) -> void:
    rpc_id(1, "_send_input", input)

func update_player_username(username: String) -> void:
    rpc_id(1, "_update_player_username", username)

# Master network methods

master func _send_input(input: Dictionary) -> void:
    var peer_id := SxNetwork.get_sender_nuid(self)
    _get_sync_input().update_peer_input_from_json(peer_id, input)

master func _ping() -> void:
    var my_id := SxNetwork.get_nuid(self)
    var peer_id := SxNetwork.get_sender_nuid(self)

    _logger.debug_mn(my_id, "_ping", "Ping request received from peer '%d'." % peer_id)
    _get_client().pong(peer_id)

master func _update_player_username(username: String) -> void:
    var my_id := SxNetwork.get_nuid(self)
    var peer_id := SxNetwork.get_sender_nuid(self)
    _logger.debug_mn(my_id, "_update_player_username", "Player %d updated its username to %s." % [peer_id, username])
    emit_signal("player_username_updated", peer_id, username)
