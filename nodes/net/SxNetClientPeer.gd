extends Node
class_name SxNetClientPeer
## A ready-to-use "scoped" network client peer, with logging and WebSockets abstraction.
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
## Client just connected to server.
signal connected_to_server()
## Server connection failed.
signal connection_failed()
## Disconnected from server.
signal server_disconnected()

## Server address to use to connect.
@export var server_address: String
## Server port to use to connect.
@export var server_port: int
## Use WebSockets instead of ENet (WebSockets will be forced on Web).
@export var use_websockets: bool = false

## Peer protocol node, used to send messages between server and client.
var protocol: SxNetPeerProtocol

var _multiplayer_api: MultiplayerAPI
var _logger: SxLog.Logger

func _init() -> void:
    name = "SxNetClientPeer"
    _logger = SxLog.get_logger("SxNetClientPeer")

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
    _multiplayer_api.connected_to_server.connect(func():
        _logger.info("Connected to server.")

        # Spawn the protocol.
        protocol = SxNetPeerProtocol.new()
        add_child(protocol)

        connected_to_server.emit()
    )
    _multiplayer_api.connection_failed.connect(func():
        _logger.info("Connection to server failed.")
        connection_failed.emit()
    )
    _multiplayer_api.server_disconnected.connect(func():
        _logger.info("Server disconnected.")
        server_disconnected.emit()
    )

    # On Web, force WebSockets because ENet does not work.
    if OS.get_name() == "Web":
        use_websockets = true

    var peer: MultiplayerPeer
    if use_websockets:
        var ws_peer := WebSocketMultiplayerPeer.new()
        var error := ws_peer.create_client(server_address + ":" + str(server_port))
        if error:
            _logger.error("Error while creating client: %s", [error])
            return
        _logger.info("Creating WebSockets client...")
        peer = ws_peer
    else:
        var en_peer := ENetMultiplayerPeer.new()
        var error := en_peer.create_client(server_address, server_port)
        if error:
            _logger.error("Error while creating client: %s", [error])
            return
        _logger.info("Creating ENet client...")
        peer = en_peer

    var client_root_path := self.get_path()
    get_tree().set_multiplayer(_multiplayer_api, client_root_path)
    _multiplayer_api.multiplayer_peer = peer

    _logger.info("Client created.")
    _logger.info("Trying to connect to %s:%d...", [server_address, server_port])

func _process(delta: float) -> void:
    if _multiplayer_api.has_multiplayer_peer():
        _multiplayer_api.poll()

func _exit_tree() -> void:
    if _multiplayer_api.has_multiplayer_peer():
        multiplayer.multiplayer_peer = null
