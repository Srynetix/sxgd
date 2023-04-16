extends Node
class_name SxServerPeer

signal peer_connected(peer_id)
signal peer_disconnected(peer_id)
signal players_updated(players)

@export var use_websockets := false

class SxSynchronizedScenePath:
    extends Object

    var guid: String
    var name: String
    var parent: NodePath
    var scene_path: String
    var owner_peer_id: int
    var master_configuration: Dictionary

    func _init(guid_: String, name_: String, parent_: NodePath, scene_path_: String, owner_peer_id_: int, master_configuration_: Dictionary) -> void:
        guid = guid_
        name = name_
        parent = parent_
        scene_path = scene_path_
        owner_peer_id = owner_peer_id_
        master_configuration = master_configuration_

var server_port := 0
var max_players := 0
var rpc_service: SxRpcService

var _players := {}
var _logger := SxLog.get_logger("SxServerPeer")
var _sync_scene_paths := {}
var _sync_nodes := {}
var _quitting := false
var _ws_server: WebSocketMultiplayerPeer

func _init() -> void:
    name = "SxServerPeer"
    _logger.set_max_log_level(SxLog.LogLevel.DEBUG)
    assert(!SxOs.is_web(),"You can't host a server on Web platforms for now.")

func _get_client() -> SxClientRpc:
    return rpc_service.client

func _get_sync_input() -> SxSyncInput:
    return rpc_service.sync_input

func get_players() -> Dictionary:
    return _players

func _ready() -> void:
    get_tree().peer_connected.connect(_peer_connected)
    get_tree().peer_disconnected.connect(_peer_disconnected)

    if rpc_service == null:
        rpc_service = SxRpcService.get_from_tree(get_tree())

    if use_websockets:
        _ws_server = WebSocketMultiplayerPeer.new()
        _ws_server.create_server(server_port, )
        _ws_server.allow_object_decoding = true
        get_tree().network_peer = _ws_server

        rpc_service.server.player_username_updated.connect(_on_player_username_updated)
        _logger.debug_m("_ready", "WebSocket server started on port '%d'" % server_port)
    else:
        var peer = ENetMultiplayerPeer.new()
        peer.create_server(server_port, max_players)
        peer.allow_object_decoding = true
        get_tree().network_peer = peer

        rpc_service.server.player_username_updated.connect(_on_player_username_updated)
        _logger.debug_m("_ready", "Server started on port '%d'" % server_port)

func _peer_connected(peer_id: int) -> void:
    _logger.debug_m("_peer_connected", "Peer '%d' connected." % peer_id)
    _get_sync_input().create_peer_input(peer_id)
    _players[peer_id] = "Player"

    _spawn_existing_scenes(peer_id)
    _get_client().synchronize_players_broadcast(_players)
    emit_signal("peer_connected", peer_id)
    emit_signal("players_updated", _players)

func _spawn_existing_scenes(peer_id: int) -> void:
    _logger.debug_m("_spawn_existing_scenes", "Spawning existing scenes on peer '%d'." % peer_id)

    for k in _sync_scene_paths:
        var ssp: SxSynchronizedScenePath = _sync_scene_paths[k]
        _get_client().spawn_synchronized_scene_on(
            peer_id,
            ssp.parent,
            ssp.name,
            ssp.scene_path,
            ssp.guid,
            ssp.owner_peer_id,
            ssp.master_configuration
        )

func _peer_disconnected(peer_id: int) -> void:
    _logger.debug_m("_peer_disconnected", "Peer '%d' disconnected." % peer_id)
    _get_sync_input().remove_peer_input(peer_id)
    _players.erase(peer_id)

    _get_client().synchronize_players_broadcast(_players)
    emit_signal("peer_disconnected", peer_id)
    emit_signal("players_updated", _players)

func _physics_process(_delta: float) -> void:
    for k in _sync_nodes:
        var node: Node = _sync_nodes[k]
        if node.has_method("_network_send"):
            var data: Dictionary = node.call("_network_send")
            if data != null && len(data) > 0:
                _get_client().synchronize_node_broadcast(node.get_path(), data)

    if use_websockets:
        _ws_server.poll()

func spawn_synchronized_scene(parent: NodePath, scene_path: String, owner_peer_id: int = 1, master_configuration: Dictionary = {}) -> Node:
    var uuid := SxNetwork.uuid4()
    var parent_node := get_node(parent)
    var packed_scene: PackedScene = load(scene_path)
    var child_node := packed_scene.instantiate()
    child_node.name = uuid
    child_node.set_multiplayer_authority(owner_peer_id)
    parent_node.add_child(child_node)

    if len(master_configuration) > 0:
        for key in master_configuration:
            child_node.get_node(key).set_multiplayer_authority(master_configuration[key])

    _sync_scene_paths[uuid] = SxSynchronizedScenePath.new(
        uuid,
        uuid,
        parent,
        scene_path,
        owner_peer_id,
        master_configuration
    )
    _sync_nodes[uuid] = child_node

    # Send command to all connected clients
    _get_client().spawn_synchronized_scene_broadcast(parent, uuid, scene_path, uuid, owner_peer_id, master_configuration)
    return child_node

func spawn_synchronized_named_scene(parent: NodePath, scene_path: String, scene_name: String, owner_peer_id: int = 1, master_configuration: Dictionary = {}) -> Node:
    var parent_node := get_node(parent)
    var packed_scene: PackedScene = load(scene_path)
    var child_node := packed_scene.instantiate()
    child_node.name = scene_name
    child_node.set_multiplayer_authority(owner_peer_id)
    parent_node.add_child(child_node)

    if len(master_configuration) > 0:
        for key in master_configuration:
            child_node.get_node(key).set_multiplayer_authority(master_configuration[key])

    _sync_scene_paths[scene_name] = SxSynchronizedScenePath.new(
        "",
        scene_name,
        parent,
        scene_path,
        owner_peer_id,
        master_configuration
    )
    _sync_nodes[scene_name] = child_node

    # Send command to all connected clients
    _get_client().spawn_synchronized_scene_broadcast(parent, scene_name, scene_path, "", owner_peer_id, master_configuration)
    return child_node

func spawn_synchronized_scene_mapped(parent: NodePath, name: String, server_scene_path: String, client_scene_path: String, owner_peer_id: int = 1, master_configuration: Dictionary = {}) -> Node:
    var uuid := SxNetwork.uuid4()
    var parent_node := get_node(parent)
    var packed_scene: PackedScene = load(server_scene_path)
    var child_node := packed_scene.instantiate()
    child_node.name = SxNetwork.generate_network_name(name, uuid)
    child_node.set_multiplayer_authority(owner_peer_id)
    parent_node.add_child(child_node)

    if len(master_configuration) > 0:
        for key in master_configuration:
            child_node.get_node(key).set_multiplayer_authority(master_configuration[key])

    _sync_scene_paths[uuid] = SxSynchronizedScenePath.new(
        uuid,
        name,
        parent,
        client_scene_path,
        owner_peer_id,
        master_configuration
    )
    _sync_nodes[uuid] = child_node

    # Send command to all connected clients
    _get_client().spawn_synchronized_scene_broadcast(parent, name, client_scene_path, uuid, owner_peer_id, master_configuration)
    return child_node

func remove_synchronized_node(node: Node) -> void:
    var uuid = node.name
    _sync_nodes.erase(uuid)
    _sync_scene_paths.erase(uuid)

    _get_client().remove_synchronized_node_broadcast(node.get_path())
    node.queue_free()

func is_quitting() -> bool:
    return _quitting

func set_quit_status(value: bool) -> void:
    _quitting = value

func _on_player_username_updated(player_id: int, username: String) -> void:
    _players[player_id] = username
    _get_client().synchronize_players_broadcast(_players)
    emit_signal("players_updated", _players)
