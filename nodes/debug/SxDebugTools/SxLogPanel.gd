# Log panel, display scrollable logs.
extends MarginContainer
class_name SxLogPanel

const NORMAL_FONT_DATA = preload("res://addons/sxgd/assets/fonts/OfficeCodePro-Regular.otf")
const BOLD_FONT_DATA = preload("res://addons/sxgd/assets/fonts/OfficeCodePro-Bold.otf")

# Max messages to display.
export var max_messages := 100

var _last_message: SxLog.LogMessage
var _template: RichTextLabel
var _container: VBoxContainer

func _ready():
    var normal_font := DynamicFont.new()
    normal_font.size = 12
    normal_font.outline_size = 1
    normal_font.outline_color = Color.black
    normal_font.use_mipmaps = true
    normal_font.use_filter = true
    normal_font.font_data = NORMAL_FONT_DATA

    var bold_font := DynamicFont.new()
    bold_font.size = 12
    bold_font.outline_size = 1
    bold_font.outline_color = Color.black
    bold_font.use_mipmaps = true
    bold_font.use_filter = true
    bold_font.font_data = BOLD_FONT_DATA

    anchor_right = 1.0
    anchor_bottom = 1.0
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    size_flags_vertical = Control.SIZE_EXPAND_FILL
    set("custom_constants/margin_right", 10)
    set("custom_constants/margin_top", 10)
    set("custom_constants/margin_left", 10)
    set("custom_constants/margin_bottom", 10)

    var scroll_container := ScrollContainer.new()
    add_child(scroll_container)

    _container = VBoxContainer.new()
    _container.mouse_filter = Control.MOUSE_FILTER_IGNORE
    _container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    _container.alignment = BoxContainer.ALIGN_END
    scroll_container.add_child(_container)

    _template = RichTextLabel.new()
    _template.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_SHRINK_END
    _template.set("custom_fonts/bold_font", bold_font)
    _template.set("custom_fonts/normal_font", normal_font)
    _template.bbcode_enabled = true
    _template.bbcode_text = "Hello."
    _template.fit_content_height = true
    _template.scroll_active = false

    _update_text()

func _process(delta: float):
    _update_text()

# Toggle the log panel.
func toggle():
    visible = !visible

func _update_text():
    for entry in SxLog.pop_messages():
        var message := entry as SxLog.LogMessage
        var logger_name := message.logger_name
        if logger_name == "":
            logger_name = "root"

        var text := "[b][color=yellow][%0.3f][/color][/b] " % message.time
        text += "[b][color=yellow][%s][/color][/b] " % SxLog._LogUtils.level_to_string(message.level).to_upper()
        text += "[b][color=green][%s][/color][/b] " % message.logger_name

        if message.level == SxLog.LogLevel.ERROR:
            text += "[color=red]%s[/color]" % message.message
        else:
            text += message.message

        var block := _template.duplicate()
        block.bbcode_text = text
        _container.add_child(block)

        # Remove old messages
        while _container.get_child_count() >= max_messages:
            var old := _container.get_child(0)
            old.queue_free()
            _container.remove_child(old)
