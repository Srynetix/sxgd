# A wrapper around a SxAudioMultiStreamPlayer, to be used through inheritance as an autoload, which means:
#
# - inherit the node in your game,
# - configure the `streams` parameter,
# - and set it as **autoload**.

extends Node
class_name SxGlobalAudioFxPlayer

# Maximum simultaneous voices.
export(int, 1, 16) var max_voices := 4
# Audio bus output
export var audio_bus_output := "Master"
# Audio streams to play
export var streams := {}

var player: SxAudioMultiStreamPlayer

# Get voice by index.
func get_voice(voice: int) -> AudioStreamPlayer:
    return player.get_voice(voice)

# Play a stream on an automatically selected voice, or a specific voice.
func play(stream_name: String, voice: int = -1) -> void:
    if voice == -1:
        player.play(streams[stream_name])
    else:
        player.play_on_voice(streams[stream_name], voice)

func _ready() -> void:
    var player_scene: PackedScene = load("res://addons/sxgd/nodes/audio/SxAudioMultiStreamPlayer/SxAudioMultiStreamPlayer.tscn")
    player = player_scene.instance()
    player.max_voices = max_voices
    player.audio_bus_output = audio_bus_output
    add_child(player)
