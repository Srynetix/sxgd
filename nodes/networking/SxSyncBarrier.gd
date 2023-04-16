extends Node
class_name SxSyncBarrier

enum BarrierJoinStatus {
    NOT_READY = 0,
    OK,
    TIMEOUT
}

const DEFAULT_TIMEOUT = 60  # seconds

var _count := 0
var _timeout := 0
var _startup_time := 0
var _server_peer: SxServerPeer
var _logger := SxLog.get_logger("SxSyncBarrier")
var _status := BarrierJoinStatus.NOT_READY as int

func _init(name_: String, timeout: int = DEFAULT_TIMEOUT) -> void:
    name = name_
    _timeout = timeout

func set_server_peer(peer: SxServerPeer):
    _server_peer = peer

func _ready() -> void:
    if !SxNetwork.is_server(get_tree()):
        rpc_id(1, "_peer_ready")
        queue_free()
    else:
        _startup_time = Time.get_ticks_msec() / 1000

@rpc("any_peer") func _peer_ready() -> void:
    var peer_id = SxNetwork.get_sender_nuid(self)
    _logger.debug_m("_peer_ready", "Peer %d is ready for barrier %s" % [peer_id, self])
    _count += 1

func _validate_ready_peers() -> bool:
    if _count >= len(_server_peer.get_players()):
        _logger.debug_m("_validate_ready_peers", "Everyone is ready for barrier %s." % self)
        _status = BarrierJoinStatus.OK
        return true
    return false

func await_peers() -> void:
    var elapsed_time := Time.get_ticks_msec() / 1000 - _startup_time
    while elapsed_time < _timeout:
        if _validate_ready_peers():
            queue_free()
            return
        await get_tree().create_timer(1).timeout
        if _validate_ready_peers():
            queue_free()
            return

    _status = BarrierJoinStatus.TIMEOUT
    queue_free()
    return
