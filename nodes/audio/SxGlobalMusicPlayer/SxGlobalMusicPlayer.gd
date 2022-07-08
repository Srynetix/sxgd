# An audio player, used to play sound tracks, to be used through inheritance as an autoload.
# (see [SxGlobalAudioFxPlayer](../SxGlobalAudioFxPlayer/SxGlobalAudioFxPlayer.md)).

extends AudioStreamPlayer
class_name SxGlobalMusicPlayer

onready var tween: Tween = $Tween

# Global volume in DB
var global_volume_db: float setget _set_global_volume_db

# Apply a "fade in" effect on sound with an optional duration in seconds.
# Duration defaults to 0.5 seconds.
#
# Examples:
#   player.fade_in()
#   player.fade_in(2.0)
func fade_in(duration: float = 0.5) -> void:
    tween.stop_all()
    tween.interpolate_property(self, "volume_db", -100, global_volume_db, duration)
    tween.start()

# Apply a "fade out" effect on sound with an optional duration in seconds.
# Duration defaults to 0.5 seconds.
#
# Examples:
#   player.fade_out()
#   player.fade_out(2.0)
func fade_out(duration: float = 0.5) -> void:
    tween.stop_all()
    tween.interpolate_property(self, "volume_db", global_volume_db, -100, duration)
    tween.start()

# Plays an audio stream.
#
# Example:
#   player.play_stream(my_stream)
func play_stream(stream_: AudioStream) -> void:
    stream = stream_
    play()

func _set_global_volume_db(value: float):
    global_volume_db = value
    volume_db = value

func _ready():
    global_volume_db = volume_db
