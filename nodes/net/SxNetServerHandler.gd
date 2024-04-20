extends Node
class_name SxNetServerHandler
## A simple server helper linked to a [SxNetServerPeer] (with a [SxNetPeerProtocol]).
##
## Exposes `_peer_connected`, `_peer_disconnected` and `_on_message` functions you can
## override to react to events and client messages.

var peer: SxNetServerPeer
var protocol: SxNetPeerProtocol

func _init(peer_: SxNetServerPeer) -> void:
    peer = peer_
    protocol = peer.protocol
    name = "SxNetServerHandler"

func _ready() -> void:
    peer.peer_connected.connect(_peer_connected)
    peer.peer_disconnected.connect(_peer_disconnected)
    protocol.on_message_for_server.connect(_on_message)

## A peer just connected.
func _peer_connected(id: int) -> void:
    pass

## A peer just disconnected.
func _peer_disconnected(id: int) -> void:
    pass

func _on_message(peer_id: int, kind: Variant, payload: Variant) -> void:
    pass
