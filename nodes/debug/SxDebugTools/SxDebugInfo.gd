# A debug panel showing performance info, shown with the F12 key.
# When shown, you can reload the current scene with F5 and pause the game with F2.
tool
extends CanvasLayer
class_name SxDebugInfo

const FONT_DATA := preload("res://addons/sxgd/assets/fonts/Jost-400-Book.ttf")

var _label: RichTextLabel

# Get the visibility status.
func get_visibility() -> bool:
    return _label.visible

# Set the visibility status.
func set_visibility(value: bool) -> void:
    _label.visible = value

func _ready() -> void:
    pause_mode = PAUSE_MODE_PROCESS
    layer = 99
    name = "SxDebugInfo"

    var font := DynamicFont.new()
    font.size = 12
    font.outline_size = 1
    font.outline_color = Color.black
    font.use_mipmaps = true
    font.use_filter = true
    font.font_data = FONT_DATA

    var container := MarginContainer.new()
    container.set_anchors_and_margins_preset(Control.PRESET_WIDE)
    container.mouse_filter = Control.MOUSE_FILTER_IGNORE
    container.set("custom_constants/margin_right", 10)
    container.set("custom_constants/margin_left", 10)
    container.set("custom_constants/margin_top", 10)
    container.set("custom_constants/margin_bottom", 10)
    add_child(container)

    _label = RichTextLabel.new()
    _label.margin_left = 10.0
    _label.margin_top = 10.0
    _label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    _label.set("custom_colors/default_color", Color(1, 0.43, 0.52, 1))
    _label.set("custom_fonts/normal_font", font)
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
        text += " 2D Draw calls: %s\n" % Performance.get_monitor(Performance.RENDER_2D_DRAW_CALLS_IN_FRAME)
        text += " Draw calls: %s\n" % Performance.get_monitor(Performance.RENDER_DRAW_CALLS_IN_FRAME)
        text += " 2D items: %s\n" % Performance.get_monitor(Performance.RENDER_2D_ITEMS_IN_FRAME)
        text += "\n"
        text += " Object count: %s\n" % Performance.get_monitor(Performance.OBJECT_COUNT)
        text += " Node count: %s\n" % Performance.get_monitor(Performance.OBJECT_NODE_COUNT)
        text += " Orphan node count: %s\n" % Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)
        text += " Resource count: %s\n" % Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT)

        _label.text = text
