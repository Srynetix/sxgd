extends Node
class_name SxSyncPeerInput

const SETTING_SYNC_PEER_INPUT_ACTIONS = "sxgd/networking/sync_peer_input_actions"

class InputState:
    var pressed := false
    var just_pressed := false
    var strength := 0.0

    func to_json() -> Dictionary:
        return {
            "pressed": pressed,
            "just_pressed": just_pressed,
            "strength": strength
        }

    func update_from_json(d: Dictionary) -> void:
        pressed = d["pressed"]
        just_pressed = d["just_pressed"]
        strength = d["strength"]

var _input_state := {}
var _actions := []
var _logger := SxLog.get_logger("SxSyncPeerInput")

func _load_known_actions() -> PackedStringArray:
    # Read known actions from ProjectSettings.
    if ProjectSettings.has_setting(SETTING_SYNC_PEER_INPUT_ACTIONS):
        var conf := ProjectSettings.get(SETTING_SYNC_PEER_INPUT_ACTIONS) as PackedStringArray
        if len(conf) != 0:
            return conf
    push_warning("Using SxSyncPeerInput with no actions defined in %s. Set them in the Project Settings."  % SETTING_SYNC_PEER_INPUT_ACTIONS)
    return PackedStringArray()

func _init(peer_id: int = 1) -> void:
    name = "SxSyncPeerInput#%d" % peer_id
    set_multiplayer_authority(peer_id)
    _actions = _load_known_actions()

    for action in _actions:
        _input_state[action] = InputState.new()

    _logger.set_max_log_level(SxLog.LogLevel.DEBUG)

func to_json() -> Dictionary:
    var s := {}
    for k in _input_state:
        s[k] = _input_state[k].to_json()
    return s

func update_from_json(input: Dictionary) -> void:
    for k in input:
        _input_state[k].update_from_json(input[k])

func is_action_pressed(action_name: String) -> bool:
    if _input_state.has(action_name):
        return _input_state[action_name].pressed
    else:
        return false

func is_action_just_pressed(action_name: String) -> bool:
    # TO FIX
    if _input_state.has(action_name):
        return _input_state[action_name].just_pressed
    else:
        return false

func get_action_strength(action_name: String) -> float:
    if _input_state.has(action_name):
        return _input_state[action_name].strength
    else:
        return 0.0

func query_input() -> void:
    if SxNetwork.is_network_master(self):
        for action in _actions:
            _input_state[action].pressed = Input.is_action_pressed(action)
            _input_state[action].just_pressed = Input.is_action_just_pressed(action)
            _input_state[action].strength = Input.get_action_strength(action)

func _trace_input() -> void:
    var should_trace := false
    for k in _input_state:
        if _input_state[k] != 0:
            should_trace = true
            break

    if should_trace:
        _logger.debug_mn(SxNetwork.get_nuid(self), "_trace_input", "%s" % _input_state)
