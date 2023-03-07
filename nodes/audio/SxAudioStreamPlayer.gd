# A 'supercharged' AudioStreamPlayer with multiple simultaneous voices,
# configurable through the `max_voices` parameter.

extends Node
class_name SxAudioStreamPlayer

const MUTED_VOLUME = -100.0

# Maximum simultaneous voices.
export(int, 1, 16) var max_voices := 4
# Audio bus output
export var audio_bus_output := "Master"
# Audio streams to play
export var streams := {}
# Initial volume for each audio players
export var initial_volume_db := 0.0

var _players := Array()
var _player_data := {}

# Play an audio stream on an automatically selected voice.
func play_stream(stream: AudioStream) -> void:
    var available := _find_available_player()
    if available != null:
        _play_stream_on_player(stream, available)
    else:
        _play_stream_on_player(stream, _find_oldest_active_player())

# Play an audio stream on a specific voice.
func play_stream_on_voice(stream: AudioStream, voice: int) -> void:
    var player := _players[voice] as AudioStreamPlayer
    _play_stream_on_player(stream, player)

# Play a stored audio stream by key on an automatically selected voice.
func play_key(key: String) -> void:
    var stream := streams.get(key) as AudioStream
    if !stream:
        push_error("Unknown audio stream with key " + key)
        return

    play_stream(stream)

# Play a stored audio stream by key on a specific voice.
func play_key_on_voice(key: String, voice: int) -> void:
    var stream := streams.get(key) as AudioStream
    if !stream:
        push_error("Unknown audio stream with key " + key)
        return

    play_stream_on_voice(stream, voice)

# Apply a "fade in" effect on sound with an optional duration in seconds.
func fade_in_on_voice(voice: int, duration: float = 0.5) -> void:
    var player := _players[voice] as AudioStreamPlayer
    var last_tweaked_volume := _player_data[player]["volume_db"] as float
    player.volume_db = MUTED_VOLUME

    var tween = create_tween()
    tween.tween_property(player, "volume_db", last_tweaked_volume, duration)
    yield(tween, "finished")

# Apply a "fade out" effect on sound with an optional duration in seconds.
# Duration defaults to 0.5 seconds.
func fade_out_on_voice(voice: int, duration: float = 0.5) -> void:
    var player := _players[voice] as AudioStreamPlayer

    var tween = create_tween()
    tween.tween_property(player, "volume_db", MUTED_VOLUME, duration)
    yield(tween, "finished")

func set_volume_on_voice(voice: int, volume: float) -> void:
    var player := _players[voice] as AudioStreamPlayer
    _player_data[player]["volume_db"] = volume
    player.volume_db = volume

func get_volume_on_voice(voice: int) -> float:
    var player := _players[voice] as AudioStreamPlayer
    return player.volume_db

func get_voice(voice: int) -> AudioStreamPlayer:
    return _players[voice] as AudioStreamPlayer

func _play_stream_on_player(stream: AudioStream, player: AudioStreamPlayer) -> void:
    player.stop()
    player.stream = stream
    player.play()

func _find_available_player() -> AudioStreamPlayer:
    for p in _players:
        var player := p as AudioStreamPlayer
        if !player.playing:
            return player

    return null

func _find_oldest_active_player() -> AudioStreamPlayer:
    var oldest_player := _players[0] as AudioStreamPlayer
    var playback_pos := oldest_player.get_playback_position()

    for i in range(1, max_voices):
        var player := _players[i] as AudioStreamPlayer
        var pos := player.get_playback_position()
        if pos > playback_pos:
            playback_pos = pos
            oldest_player = player

    return oldest_player

func _ready() -> void:
    for i in range(max_voices):
        var player := AudioStreamPlayer.new()
        player.volume_db = initial_volume_db
        add_child(player)

        player.bus = audio_bus_output
        _players.append(player)
        _player_data[player] = {
            "volume_db": player.volume_db
        }
