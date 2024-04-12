@tool
extends Control
class_name SxFPSCrosshair
## Dummy FPS crosshair.

## Crosshair size.
@export var crosshair_size = Vector2(25, 15)
## Crosshair color.
@export var crosshair_color = Color.RED
## Crosshair width.
@export var crosshair_width = 1

func _ready():
    set_anchors_and_offsets_preset(Control.PRESET_CENTER)

func _process(_delta: float) -> void:
    queue_redraw()

func _draw() -> void:
    draw_line(Vector2.LEFT * crosshair_size.x, Vector2.RIGHT * crosshair_size.x, crosshair_color, crosshair_width)
    draw_line(Vector2.UP * crosshair_size.y, Vector2.DOWN * crosshair_size.y, crosshair_color, crosshair_width)
