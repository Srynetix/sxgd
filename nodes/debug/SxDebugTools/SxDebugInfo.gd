extends Control
class_name SxDebugInfo
## A debug panel showing performance info.

var _label: RichTextLabel

## Get the visibility status.
func get_visibility() -> bool:
    return _label.visible

## Set the visibility status.
func set_visibility(value: bool) -> void:
    _label.visible = value

func _init() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS
    name = "SxDebugInfo"

func _ready() -> void:
    var container := MarginContainer.new()
    container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    container.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(container)

    _label = RichTextLabel.new()
    _label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    _label.text = "FPS"
    container.add_child(_label)

func _process(delta):
    if _label.visible:
        var version := Engine.get_version_info()
        var mem_used_bytes := Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)
        var mem_used_megs := mem_used_bytes / 1000000.0

        var text := ""
        text += " Godot Engine %s\n" % version["string"]
        text += " FPS: %s\n" % Engine.get_frames_per_second()
        text += " Process time: %s ms\n" % (Performance.get_monitor(Performance.TIME_PROCESS) * 1000)
        text += " Physics process time: %s ms\n" % (Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS) * 1000)
        text += " Audio latency: %s ms\n" % (Performance.get_monitor(Performance.AUDIO_OUTPUT_LATENCY) * 1000)
        text += " Video memory used: %s MB\n" % (mem_used_megs)
        text += "\n"
        text += " Draw calls: %s\n" % Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
        text += "\n"
        text += " Object count: %s\n" % Performance.get_monitor(Performance.OBJECT_COUNT)
        text += " Node count: %s\n" % Performance.get_monitor(Performance.OBJECT_NODE_COUNT)
        text += " Orphan node count: %s\n" % Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)
        text += " Resource count: %s\n" % Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT)

        _label.text = text
