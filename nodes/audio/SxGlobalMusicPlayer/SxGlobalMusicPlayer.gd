extends AudioStreamPlayer
class_name SxGlobalMusicPlayer

onready var tween: Tween = $Tween

var global_volume_db: float setget _set_global_volume_db

func _set_global_volume_db(value: float):
    global_volume_db = value
    volume_db = value

func _ready():
    global_volume_db = volume_db

# Plays an audio stream.
#
# Example:
#   player.play_stream(my_stream)
func play_stream(stream: AudioStream) -> void:
    self.stream = stream
    play()

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
