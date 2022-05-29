extends Node
class_name SxGlobalAudioFxPlayer

# Maximum simultaneous voices.
export(int, 1, 16) var max_voices = 4
export(Dictionary) var streams = {}

var player: SxAudioMultiStreamPlayer

func _ready():
    var player_scene: PackedScene = load("res://addons/sxgd/nodes/audio/SxAudioMultiStreamPlayer/SxAudioMultiStreamPlayer.tscn")
    player = player_scene.instance()
    player.max_voices = max_voices
    add_child(player)

func play(stream_name: String, voice: int = -1):
    if voice == -1:
        player.play(streams[stream_name])
    else:
        player.play_on_voice(streams[stream_name], voice)

func get_voice(voice: int) -> AudioStreamPlayer:
    return player.get_voice(voice)
