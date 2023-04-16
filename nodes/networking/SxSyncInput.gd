extends Node
class_name SxSyncInput

var _logger := SxLog.get_logger("SxSyncInput")
var _player_inputs := {}

func _init() -> void:
    name = "SxSyncInput"
    _logger.set_max_log_level(SxLog.LogLevel.DEBUG)

func get_current_input() -> SxSyncPeerInput:
    var my_id = SxNetwork.get_nuid(self)
    if _player_inputs.has(my_id):
        return _player_inputs[my_id]
    return null

func create_peer_input(peer_id: int) -> void:
    var input = SxSyncPeerInput.new(peer_id)
    add_child(input)

    _player_inputs[peer_id] = input
    _logger.debug_mn(SxNetwork.get_nuid(self), "create_peer_input", "Created peer input for peer '%d' (now: %s)" % [peer_id, _player_inputs.keys()])

func remove_peer_input(peer_id: int) -> void:
    if _player_inputs.has(peer_id):
        _player_inputs[peer_id].queue_free()
        _player_inputs.erase(peer_id)

func update_peer_input_from_json(peer_id: int, input: Dictionary) -> void:
    _player_inputs[peer_id].update_from_json(input)

func is_action_pressed(source: Node, action_name: String) -> bool:
    if !SxNetwork.is_network_enabled(get_tree()):
        return Input.is_action_pressed(action_name)
    else:
        var source_id = source.get_multiplayer_authority()
        if source_id == 1:
            # Do not handle server input
            return false

        if _player_inputs.has(source_id):
            return _player_inputs[source_id].is_action_pressed(action_name)
        else:
            push_error("Player input for ID %d is missing." % source_id)
            return false

func is_action_just_pressed(source: Node, action_name: String) -> bool:
    if !SxNetwork.is_network_enabled(get_tree()):
        return Input.is_action_just_pressed(action_name)
    else:
        var source_id = source.get_multiplayer_authority()
        if source_id == 1:
            # Do not handle server input
            return false

        if _player_inputs.has(source_id):
            return _player_inputs[source_id].is_action_just_pressed(action_name)
        else:
            return false

func get_action_strength(source: Node, action_name: String) -> float:
    if !SxNetwork.is_network_enabled(get_tree()):
        return Input.get_action_strength(action_name)
    else:
        var source_id = source.get_multiplayer_authority()
        if source_id == 1:
            # Do not handle server input
            return 0.0

        if _player_inputs.has(source_id):
            return _player_inputs[source_id].get_action_strength(action_name)
        else:
            return 0.0
