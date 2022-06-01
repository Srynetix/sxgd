# A debug panel showing performance info, shown with the F12 key.
# When shown, you can reload the current scene with F5 and pause the game with F2.
#
# <p align="center">
#   <img src="../../../../images/nodes/SxDebugInfo.png" alt="capture" />
# </p>
extends CanvasLayer
class_name SxDebugInfo

export var visible_on_startup: bool = false

onready var _label: RichTextLabel = $MarginContainer/RichTextLabel

func _ready():
    _label.visible = visible_on_startup

func _input(event: InputEvent):
    if event is InputEventKey:
        if event.pressed && event.scancode == KEY_F12:
            _label.visible = !_label.visible

        elif event.pressed && event.scancode == KEY_F5 && _label.visible:
            get_tree().reload_current_scene()

        elif event.pressed && event.scancode == KEY_F2 && _label.visible:
            get_tree().paused = !get_tree().paused

func _process(delta):
    if _label.visible:
        var version = Engine.get_version_info()
        var mem_used_bytes = Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)
        var mem_used_megs = mem_used_bytes / 1000000.0

        var text = ""
        text += " Godot Engine %s\n" % version["string"]
        text += " FPS: %s\n" % Engine.get_frames_per_second()
        text += " Process time: %s ms\n" % (Performance.get_monitor(Performance.TIME_PROCESS) * 1000)
        text += " Physics process time: %s ms\n" % (Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS) * 1000)
        text += " Audio latency: %s ms\n" % (Performance.get_monitor(Performance.AUDIO_OUTPUT_LATENCY) * 1000)
        text += " Video memory used: %s MB\n" % (mem_used_megs)
        text += "\n"
        text += " 2D Draw calls: %s\n" % Performance.get_monitor(Performance.RENDER_2D_DRAW_CALLS_IN_FRAME)
        text += " Draw calls: %s\n" % Performance.get_monitor(Performance.RENDER_DRAW_CALLS_IN_FRAME)
        text += " 2D items: %s\n" % Performance.get_monitor(Performance.RENDER_2D_ITEMS_IN_FRAME)
        text += "\n"
        text += " Object count: %s\n" % Performance.get_monitor(Performance.OBJECT_COUNT)
        text += " Node count: %s\n" % Performance.get_monitor(Performance.OBJECT_NODE_COUNT)
        text += " Orphan node count: %s\n" % Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)
        text += " Resource count: %s\n" % Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT)

        _label.text = text
