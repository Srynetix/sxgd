extends Node
class_name SxNetPeerProtocol
## A simple "protocol", which abstracts RPC communications through common methods:
## [send_to_server], [send_to_client], [send_to_clients] and [send_to_all_clients].
##
## If using SxNetClientPeer and SxNetServerPeer, this protocol node is "guaranteed" to be present
## at the same place in both multiplayer trees, so you can use it as a bidirectional communication
## medium without polluting your other nodes.
##
## Messages sent between client and servers are composed of a `kind` and a `payload`.
## They are intentionally typed as Variant so you can use what you want.
## For example, you can define an `enum` to represent your message kinds, and use a `Dictionary` as
## a payload.
##
## It also exposes signals to react to client and server messages.

## When a client receives a message (client specific signal).
signal on_message_for_client(kind: Variant, payload: Variant)
## When a server receives a message (server specific signal).
signal on_message_for_server(peer_id: int, kind: Variant, payload: Variant)

var _logger: SxLog.Logger

func _init() -> void:
    _logger = SxLog.get_logger("SxNetPeerProtocol")
    name = "SxNetPeerProtocol"

func _ready() -> void:
    var peer_id := multiplayer.get_unique_id()
    _logger.info("PeerProtocol spawned at %s (UID: %d)", [get_path(), peer_id])

func _sizeof(obj: Variant) -> int:
    return len(var_to_bytes_with_objects(obj))

## Send a message to a server, using a `kind` and a `payload`.
func send_to_server(kind: Variant, payload: Variant = null) -> void:
    _send_to_server.rpc_id(1, kind, payload)

## Send a message to a specific client, using a `kind` and a `payload`.
func send_to_client(peer_id: int, kind: Variant, payload: Variant = null) -> void:
    _send_to_client.rpc_id(peer_id, kind, payload)

## Send a message to specific clients, using a `kind` and a `payload`.
func send_to_clients(peer_ids: Array[int], kind: Variant, payload: Variant = null) -> void:
    for peer_id in peer_ids:
        _send_to_client.rpc_id(peer_id, kind, payload)

## Send a message to every client, using a `kind` and a `payload`.
func send_to_all_clients(kind: Variant, payload: Variant = null) -> void:
    _send_to_client.rpc(kind, payload)

@rpc("any_peer", "reliable")
func _send_to_server(kind: Variant, payload: Variant) -> void:
    # Ensure we are the server
    if not multiplayer.is_server():
        return

    var sender_id = multiplayer.get_remote_sender_id()

    _logger.debug("Server received (kind=%s, peer_id=%d, payload_size=%d)", [kind, sender_id, _sizeof(payload)])
    on_message_for_server.emit(sender_id, kind, payload)

@rpc("reliable")
func _send_to_client(kind: Variant, payload: Variant) -> void:
    # Ensure we are not the server
    if multiplayer.is_server():
        return

    _logger.debug("Client received (peer_id=%d, kind=%s, payload_size=%d)", [multiplayer.get_unique_id(), kind, _sizeof(payload)])
    on_message_for_client.emit(kind, payload)
