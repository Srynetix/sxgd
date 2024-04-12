@tool
extends CanvasLayer
class_name SxDebugInfo
## A debug panel showing performance info.

const font := preload("res://addons/sxgd/assets/fonts/Jost-400-Book.ttf")

var _label: RichTextLabel

## Get the visibility status.
func get_visibility() -> bool:
    return _label.visible

## Set the visibility status.
func set_visibility(value: bool) -> void:
    _label.visible = value

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS
    layer = 99
    name = "SxDebugInfo"

    var container := MarginContainer.new()
    container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    container.mouse_filter = Control.MOUSE_FILTER_IGNORE
    container.add_theme_constant_override("margin_right", 10)
    container.add_theme_constant_override("margin_left", 10)
    container.add_theme_constant_override("margin_top", 10)
    container.add_theme_constant_override("margin_bottom", 10)
    add_child(container)

    _label = RichTextLabel.new()
    _label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    _label.add_theme_color_override("default_color", Color(1, 0.43, 0.52, 1))
    _label.add_theme_font_size_override("normal_font_size", 12)
    _label.add_theme_font_override("normal_font", font)
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
