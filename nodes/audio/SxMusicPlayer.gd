# An audio player, used to play sound tracks, to be used through inheritance as an autoload.

extends AudioStreamPlayer
class_name SxMusicPlayer

var _tween: Tween

# Global volume in DB
var global_volume_db: float setget _set_global_volume_db

# Apply a "fade in" effect on sound with an optional duration in seconds.
# Duration defaults to 0.5 seconds.
#
# Examples:
#   player.fade_in()
#   player.fade_in(2.0)
func fade_in(duration: float = 0.5) -> void:
    _tween.stop_all()
    _tween.interpolate_property(self, "volume_db", -100, global_volume_db, duration)
    _tween.start()
    yield(_tween, "tween_all_completed")

# Apply a "fade out" effect on sound with an optional duration in seconds.
# Duration defaults to 0.5 seconds.
#
# Examples:
#   player.fade_out()
#   player.fade_out(2.0)
func fade_out(duration: float = 0.5) -> void:
    _tween.stop_all()
    _tween.interpolate_property(self, "volume_db", global_volume_db, -100, duration)
    _tween.start()
    yield(_tween, "tween_all_completed")

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
    _tween = Tween.new()
    add_child(_tween)

    global_volume_db = volume_db
