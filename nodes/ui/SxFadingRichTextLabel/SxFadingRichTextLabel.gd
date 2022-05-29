extends RichTextLabel
class_name SxFadingRichTextLabel

enum Alignment { LEFT, RIGHT }

# Autoplay the text animation
export var autoplay: bool = false
# Delay per character, in seconds
export var char_delay: float = 0.1
# Fade out delay, in seconds
export var fade_out_delay: float = 2
# Text alignment
export var text_alignment = Alignment.LEFT

# Text was completely shown
signal shown()

onready var _timer: Timer = $Timer
var _tag_regex: RegEx
var _initial_text: String

func _init():
    _tag_regex = RegEx.new()
    _tag_regex.compile("(?<tag>(\\[\\\\?.*?\\]))")

func _ready():
    _initial_text = bbcode_text

    bbcode_text = ""
    _timer.connect("timeout", self, "_on_timer_timeout")

    if autoplay:
        fade_in()

# Start the "fade in" animation
#
# Example:
#   label.fade_in()
func fade_in() -> void:
    var chars_count = _strip_tags(_initial_text).length()
    var total_delay = chars_count * char_delay + fade_out_delay
    var new_bbcode = "[sxgd-fadein fadeoutdelay={fadeoutdelay} chardelay={chardelay} charscount={charscount}]{text}[/sxgd-fadein]".format({
        "fadeoutdelay": fade_out_delay,
        "chardelay": char_delay,
        "charscount": chars_count,
        "text": _initial_text
    })
    if text_alignment == Alignment.RIGHT:
        new_bbcode = "[right]{text}[/right]".format({"text": new_bbcode})

    bbcode_enabled = true
    bbcode_text = new_bbcode

    _timer.stop()
    _timer.wait_time = total_delay
    _timer.start()

# Update text to display and reset the animation.
# It will not automatically replay the animation, even with "autoplay" set.
#
# Example:
#   label.update_text("MyText")
#   label.fade_in()
func update_text(text: String) -> void:
    _initial_text = text
    bbcode_text = ""
    _timer.stop()

func _strip_tags(s: String) -> String:
    return _tag_regex.sub(s, "")

func _on_timer_timeout():
    bbcode_text = ""
    emit_signal("shown")
