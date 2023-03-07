extends Node
class_name SxClientRpc

var _logger := SxLog.get_logger("SxClientRpc")
var _service: Node  # SxRpcService

signal spawned_from_server(node)
signal removed_from_server(node)
signal players_updated(players)

func _init():
    name = "SxClientRpc"
    _logger.set_max_log_level(SxLog.LogLevel.DEBUG)

func link_service(service: Node) -> void:
    _service = service

func _get_server():
    return _service.server

func pong(peer_id: int) -> void:
    var my_id = SxNetwork.get_nuid(self)
    _logger.debug_mn(my_id, "pong", "Sending pong to peer %d." % peer_id)
    rpc_id(peer_id, "_pong")

func spawn_synchronized_scene_on(peer_id: int, parent: NodePath, name: String, scene_path: String, guid: String, owner_peer_id: int, master_configuration: Dictionary) -> void:
    var my_id = SxNetwork.get_nuid(self)
    _logger.debug_mn(my_id, "spawn_synchronized_scene_on", "Sending scene spawn '%s' named '%s' at parent '%s' with GUID '%s' and owner '%d' to peer '%d'." % [scene_path, name, parent, guid, owner_peer_id, peer_id])
    rpc_id(peer_id, "_spawn_synchronized_scene", parent, name, scene_path, guid, owner_peer_id, master_configuration)

func spawn_synchronized_scene_broadcast(parent: NodePath, name: String, scene_path: String, guid: String, owner_peer_id: int, master_configuration: Dictionary) -> void:
    var my_id = SxNetwork.get_nuid(self)
    _logger.debug_mn(my_id, "spawn_synchronized_scene_broadcast", "Sending scene spawn '%s' named '%s' at parent '%s' with GUID '%s' and owner '%d' to all peers." % [scene_path, name, parent, guid, owner_peer_id])
    rpc("_spawn_synchronized_scene", parent, name, scene_path, guid, owner_peer_id, master_configuration)

func synchronize_node_broadcast(path: NodePath, data: Dictionary) -> void:
    rpc_unreliable("_synchronize_node", path, data)

func remove_synchronized_node_on(peer_id: int, path: NodePath) -> void:
    var my_id = SxNetwork.get_nuid(self)
    _logger.debug_mn(my_id, "remove_synchronized_node_on", "Will remove node '%s' on peer '%d'." % [path, peer_id])
    rpc_id(peer_id, "_remove_synchronized_node", path)

func remove_synchronized_node_broadcast(path: NodePath) -> void:
    var my_id = SxNetwork.get_nuid(self)
    _logger.debug_mn(my_id, "remove_synchronized_node_broadcast", "Will remove node '%s' on all peers." % path)
    rpc("_remove_synchronized_node", path)

func synchronize_players_broadcast(players: Dictionary) -> void:
    var my_id = SxNetwork.get_nuid(self)
    _logger.debug_mn(my_id, "synchronize_players_broadcast", "Will synchronize players on all peers: %s" % players)
    rpc("_synchronize_players", players)

# Local network methods

remote func _pong() -> void:
    var my_id = SxNetwork.get_nuid(self)
    _logger.debug_mn(my_id, "_pong", "Pong received from server!")

remote func _spawn_synchronized_scene(parent: NodePath, name: String, scene_path: String, guid: String, owner_peer_id: int, master_configuration: Dictionary) -> void:
    var parent_node = get_node(parent)
    var child_node = load(scene_path).instance()
    child_node.name = SxNetwork.generate_network_name(name, guid)
    child_node.set_network_master(owner_peer_id)
    parent_node.add_child(child_node)

    for key in master_configuration:
        var node_path: String = key
        var owner: int = master_configuration[key]
        child_node.get_node(node_path).set_network_master(owner)

    var my_id = SxNetwork.get_nuid(self)
    _logger.debug_mn(my_id, "_spawn_synchronized_scene", "Spawned scene '%s' at parent '%s' with GUID '%s' and owner '%d'." % [scene_path, parent, guid, owner_peer_id])

    emit_signal("spawned_from_server", child_node)

remote func _synchronize_node(path: NodePath, data: Dictionary) -> void:
    var node := get_node(path)
    if node.has_method("_network_receive"):
        node.call("_network_receive", data)

remote func _remove_synchronized_node(path: NodePath) -> void:
    var my_id := SxNetwork.get_nuid(self)
    var node := get_node_or_null(path)
    if node != null:
        node.queue_free()
        _logger.debug_mn(my_id, "_remove_synchronized_node", "Removed node '%s'" % path)
    else:
        _logger.warn_mn(my_id, "_remove_synchronized_node", "Node '%s' not found, could not be removed." % path)

    emit_signal("removed_from_server", node)

remote func _synchronize_players(players: Dictionary) -> void:
    var my_id := SxNetwork.get_nuid(self)
    _logger.debug_mn(my_id, "_synchronize_players", "Players updated: '%s'" % players)
    emit_signal("players_updated", players)
