# Log panel, display scrollable logs.
extends MarginContainer
class_name SxLogPanel

# Max messages to display.
export var max_messages := 100

var last_message: SxLog.LogMessage = null
var template: RichTextLabel = null

onready var container := $ScrollContainer/VBoxContainer as VBoxContainer

func _ready():
    template = container.get_node("Label")
    container.remove_child(template)
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
        text += message.message

        var block := template.duplicate()
        block.bbcode_text = text
        container.add_child(block)

        # Remove old messages
        while container.get_child_count() >= max_messages:
            var old := container.get_child(0)
            old.queue_free()
            container.remove_child(old)
