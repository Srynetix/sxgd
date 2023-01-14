# A wrapped RichTextLabel with a per-character fade-in effect.
tool
extends RichTextLabel
class_name SxFadingRichTextLabel

const EFFECT = preload("res://addons/sxgd/nodes/ui/SxFadingRichTextLabel/SxFadingRichTextEffect.tres")

enum Alignment { LEFT, RIGHT }

# Autoplay the text animation
export var autoplay := false
# Delay per character, in seconds
export var char_delay := 0.1
# Fade out delay, in seconds
export var fade_out_delay := 2.0
# Text alignment
export(Alignment) var text_alignment := Alignment.LEFT

# Text was completely shown
signal shown()

var _timer: Timer
var _tag_regex: RegEx
var _initial_text: String

func _init():
    _tag_regex = RegEx.new()
    _tag_regex.compile("(?<tag>(\\[\\\\?.*?\\]))")

    if !rect_min_size:
        rect_min_size = Vector2(500, 0)

    mouse_filter = Control.MOUSE_FILTER_IGNORE
    bbcode_enabled = true
    scroll_active = false
    custom_effects = [EFFECT]

    _timer = Timer.new()
    _timer.one_shot = true
    add_child(_timer)

func _ready():
    if bbcode_text == "":
        _initial_text = text
    else:
        _initial_text = bbcode_text

    if Engine.editor_hint:
        if text_alignment == Alignment.RIGHT:
            bbcode_text = "[right]%s[/right]" % bbcode_text
        return

    text = ""
    bbcode_text = ""
    _timer.connect("timeout", self, "_on_timer_timeout")

    if autoplay:
        fade_in()

# Start the "fade in" animation
#
# Example:
#   label.fade_in()
func fade_in() -> void:
    var chars_count := _strip_tags(_initial_text).length()
    var total_delay := chars_count * char_delay + fade_out_delay
    var new_bbcode := "[sxgd-fadein fadeoutdelay={fadeoutdelay} chardelay={chardelay} charscount={charscount}]{text}[/sxgd-fadein]".format({
        "fadeoutdelay": fade_out_delay,
        "chardelay": char_delay,
        "charscount": chars_count,
        "text": _initial_text
    })
    if text_alignment == Alignment.RIGHT:
        new_bbcode = "[right]{text}[/right]".format({"text": new_bbcode})

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
