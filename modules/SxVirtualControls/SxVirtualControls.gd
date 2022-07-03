# A simple virtual controls module.
#
# You only need to create a new scene, inheriting from SxVirtualControls,
# and then instancing your controls in it.
#
# On buttons, you can affect an action key (mapped in the Input Map),
# and on joysticks, you can affect 4 actions keys, one for each direction.
#
# You have 3 samples at your disposal in the [samples](../../../../sxgd/modules/SxVirtualControls/samples) folder.

extends Control
class_name SxVirtualControls

# Controls display mode
enum DisplayMode {
    OnlyMobile = 0,
    Always
}

# Controls display mode, defaults to "Only mobile"
export(DisplayMode) var display_mode: int = DisplayMode.OnlyMobile

func _ready():
    visible = false
    if display_mode == DisplayMode.OnlyMobile && SxOS.is_mobile():
        visible = true
    elif display_mode == DisplayMode.Always:
        visible = true
