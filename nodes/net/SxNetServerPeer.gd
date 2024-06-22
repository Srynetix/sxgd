extends Node
class_name SxNetServerPeer
## A ready-to-use "scoped" network server peer, with logging and WebSockets abstraction.
##
## It is "scoped", meaning it uses a custom MultiplayerAPI, using its own path as a multiplayer tree.
## That means you can have multiple servers and clients on the same game instance.
##
## Comes bundled with a simple "protocol" node, the SxNetPeerProtocol which allows to send messages
## (a message kind with a message payload) between server and clients and vice-versa.
##
## See [SxNetPeerProtocol] for more info about the protocol.

## Peer just connected.
signal peer_connected(id: int)
## Peer just disconnected.
signal peer_disconnected(id: int)
## Server is ready.
signal started()

## Server port to use.
@export var port: int
## Max clients expected (only works with ENet, not WebSockets).
@export var max_clients: int = 32
## Use WebSockets instead of ENet (WebSockets will be forced on Web).
@export var use_websockets: bool = false

## Peer protocol node, used to send messages between server and client.
var protocol: SxNetPeerProtocol

var _multiplayer_api: MultiplayerAPI
var _logger: SxLog.Logger

func _init() -> void:
    name = "SxNetServerPeer"
    _logger = SxLog.get_logger("SxNetServerPeer")

func _ready() -> void:
    _multiplayer_api = MultiplayerAPI.create_default_interface()
    _multiplayer_api.peer_connected.connect(func(id):
        _logger.info("Peer connected: %d.", [id])
        peer_connected.emit(id)
    )
    _multiplayer_api.peer_disconnected.connect(func(id):
        _logger.info("Peer disconnected: %d.", [id])
        peer_disconnected.emit(id)
    )

    # On Web, force WebSockets because ENet does not work.
    if OS.get_name() == "Web":
        use_websockets = true

    var peer: MultiplayerPeer
    if use_websockets:
        var ws_peer = WebSocketMultiplayerPeer.new()
        var error := ws_peer.create_server(port)
        if error:
            _logger.error("Error while creating server: %s", [error])
            return

        _logger.info("Creating WebSockets server...")
        peer = ws_peer
    else:
        var en_peer = ENetMultiplayerPeer.new()
        var error := en_peer.create_server(port, max_clients)
        if error:
            _logger.error("Error while creating server: %s", [error])
            return
        _logger.info("Creating ENet server...")
        peer = en_peer

    var server_root_path := self.get_path()
    get_tree().set_multiplayer(_multiplayer_api, server_root_path)
    _multiplayer_api.multiplayer_peer = peer

    _logger.info("Server created.")
    _logger.info("Listening on port %d (max clients: %d)." % [port, max_clients])

    # Spawn the protocol.
    protocol = SxNetPeerProtocol.new()
    add_child(protocol)

    started.emit()

func _process(_delta: float) -> void:
    if _multiplayer_api.has_multiplayer_peer():
        _multiplayer_api.poll()

func _exit_tree() -> void:
    if _multiplayer_api.has_multiplayer_peer():
        multiplayer.multiplayer_peer = null
