extends Camera3D
class_name SxFPSCamera
## Simple FPS camera.

const MIN_LOOK_ANGLE := -90
const MAX_LOOK_ANGLE := 90

## Action to move forward.
@export var move_forward_action: String = "ui_up"
## Action to move backward.
@export var move_backward_action: String = "ui_down"
## Action to move up.
@export var move_up_action: String
## Action to move down.
@export var move_down_action: String
## Action to move left.
@export var move_left_action: String = "ui_left"
## Action to move right.
@export var move_right_action: String = "ui_right"

## Enable "noclip" mode.
@export var enable_spectator_mode: bool = false : set = _set_enable_spectator_mode

## Movement speed.
@export var movement_speed := 20
## Look sensitivity.
@export var look_sensitivity := 10

var _camera: Camera3D
var _mouse_delta := Vector2()

func _set_enable_spectator_mode(value: bool):
    enable_spectator_mode = value

    if _camera == null:
        await self.ready

    if value:
        # Swap X rotation between cameras
        rotation.x = _camera.rotation.x
        _camera.rotation.x = 0
    else:
        # Swap X rotation between cameras
        _camera.rotation.x = rotation.x
        rotation.x = 0

func _is_action_pressed(action: String) -> bool:
    if !action:
        return false
    return Input.is_action_pressed(action)

func _handle_movement() -> Vector3:
    var movement := Vector3()

    if _is_action_pressed(move_left_action):
        movement.x -= 1
    if _is_action_pressed(move_right_action):
        movement.x += 1
    if _is_action_pressed(move_forward_action):
        movement.y -= 1
    if _is_action_pressed(move_backward_action):
        movement.y += 1
    if _is_action_pressed(move_up_action):
        movement.z += 1
    if _is_action_pressed(move_down_action):
        movement.z -= 1

    return movement.normalized()

func _ready():
    _camera = Camera3D.new()
    add_child(_camera)
    _camera.current = true

    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

    # Reparent nodes
    for child in get_children():
        if child != _camera:
            remove_child(child)
            _camera.add_child(child)

func _process(delta: float) -> void:
    var movement := _handle_movement()
    var forward := transform.basis.z
    var right := transform.basis.x
    var up := transform.basis.y
    var relative_dir := (forward * movement.y + right * movement.x + up * movement.z)
    position += relative_dir * delta * movement_speed

    if enable_spectator_mode:
        var rotation = rotation_degrees
        rotation.x -= _mouse_delta.y * look_sensitivity * delta
        rotation.x = clamp(rotation.x, MIN_LOOK_ANGLE, MAX_LOOK_ANGLE)
        rotation.y -= _mouse_delta.x * look_sensitivity * delta
        rotation_degrees = rotation
    else:
        var rotation = rotation_degrees
        rotation.y -= _mouse_delta.x * look_sensitivity * delta
        rotation_degrees = rotation

        var camera_rotation = _camera.rotation_degrees
        camera_rotation.x -= _mouse_delta.y * look_sensitivity * delta
        camera_rotation.x = clamp(camera_rotation.x, MIN_LOOK_ANGLE, MAX_LOOK_ANGLE)
        _camera.rotation_degrees = camera_rotation

    _mouse_delta = Vector2()


func _input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        var motion_event := event as InputEventMouseMotion
        _mouse_delta = motion_event.relative
