# An audio player with multiple simultaneous voices, configurable through the `max_voices` parameter.

extends Node
class_name SxAudioMultiStreamPlayer

# Maximum simultaneous voices.
export(int, 1, 16) var max_voices = 4
# Audio bus output
export(String) var audio_bus_output = "Master"

var _players := Array()

# Get a voice by index.
#
# Example:
#   var first_voice = player.get_voice(0)
func get_voice(voice: int) -> AudioStreamPlayer:
    return _players[voice]

# Play a stream on an automatically selected voice.
#
# Example:
#   player.play(my_stream)
func play(stream: AudioStream) -> void:
    var available = _find_available_player()
    if available != null:
        play_on_player(stream, available)
    else:
        play_on_player(stream, _find_oldest_active_player())

# Play a stream on a specific player.
#
# Example:
#   player.play_on_player(my_sound, specific_player)
func play_on_player(stream: AudioStream, player: AudioStreamPlayer) -> void:
    player.stop()
    player.stream = stream
    player.play()

# Play a stream on a specific voice.
#
# Example:
#   player.play_on_voice(my_sound, 0)
func play_on_voice(stream: AudioStream, voice: int) -> void:
    var player: AudioStreamPlayer = _players[voice]
    play_on_player(stream, player)

func _find_available_player() -> AudioStreamPlayer:
    for p in _players:
        var player: AudioStreamPlayer = p
        if !player.playing:
            return player

    return null

func _find_oldest_active_player() -> AudioStreamPlayer:
    var oldest_player: AudioStreamPlayer = _players[0]
    var playback_pos = oldest_player.get_playback_position()

    for i in range(1, max_voices):
        var player: AudioStreamPlayer = _players[i]
        var pos = player.get_playback_position()
        if pos > playback_pos:
            playback_pos = pos
            oldest_player = player

    return oldest_player

func _ready() -> void:
    for i in range(max_voices):
        var player = AudioStreamPlayer.new()
        add_child(player)

        player.bus = audio_bus_output
        _players.append(player)
