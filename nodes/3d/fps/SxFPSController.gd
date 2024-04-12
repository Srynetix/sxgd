extends CharacterBody3D
class_name SxFPSController
## FPS controller.

class SxFPSControllerVarCollection:
    extends SxCVars.VarCollection

    var SxFPSControllerAirMoveSpeed := 10.0
    var SxFPSControllerCrouchSpeed := 2
    var SxFPSControllerDashDelay := 100
    var SxFPSControllerDashSpeed := 300.0
    var SxFPSControllerDashThreshold := 200
    var SxFPSControllerGravity := -40
    var SxFPSControllerJumpSpeed := 18
    var SxFPSControllerLookSensitivity := 10
    var SxFPSControllerMaxGroundVelocity := 10.0
    var SxFPSControllerMaxJumps := 2
    var SxFPSControllerMoveSpeed := 100.0
    var SxFPSControllerNoClip := false
    var SxFPSControllerWalkSpeed := 2

const MIN_LOOK_ANGLE := -90
const MAX_LOOK_ANGLE := 90

@export var move_forward_action: String = "ui_up"
@export var move_backward_action: String = "ui_down"
@export var move_left_action: String = "ui_left"
@export var move_right_action: String = "ui_right"
@export var peek_left_action: String
@export var peek_right_action: String
@export var jump_action: String
@export var fire_action: String
@export var crouch_action: String
@export var walk_action: String

@export var camera: Camera3D
@export var weapon: SxFPSWeapon
@export var collision_shape: CollisionShape3D
@export var hitbox: Area3D

var _acceleration := Vector3.ZERO
var _rotation_helper: Node3D
var _jumping := false
var _prev_movement_action = null
var _prev_movement_time := 0
var _dashing := false
var _walking := false
var _crouching := false
var _peeking := false
var _inside_force_field := false
var _force_field_amount := Vector3.ZERO
var _force_field_minimum_delay := 0.5
var _dash_timer: Timer
var _mouse_delta := Vector2()
var _peek_rotation: float = 0
var _current_jumps := 0
var _force_field_timer: Timer

func _ready() -> void:
    SxCVars.bind_collection(SxFPSControllerVarCollection.new())

    # Setup node
    _rotation_helper = Node3D.new()
    _rotation_helper.name = "RotationHelper"
    add_child(_rotation_helper)

    remove_child(camera)
    _rotation_helper.add_child(camera)
    add_to_group("SxFPSController")

    var remote_xform = RemoteTransform3D.new()
    remote_xform.name = "RemoteTransform3D"
    remote_xform.remote_path = NodePath("../RotationHelper")
    camera.add_child(remote_xform)

    _dash_timer = Timer.new()
    _dash_timer.timeout.connect(func(): _dashing = false)
    _dash_timer.wait_time = SxCVars.get_cvar("SxFPSControllerDashDelay") / 1000.0
    _dash_timer.one_shot = true
    add_child(_dash_timer)

    _force_field_timer = Timer.new()
    _force_field_timer.timeout.connect(func(): _inside_force_field = false)
    _force_field_timer.wait_time = _force_field_minimum_delay
    _force_field_timer.one_shot = true
    add_child(_force_field_timer)

    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

    weapon.controller = self
    hitbox.area_entered.connect(_on_hitbox_entered)

func _get_configuration_warnings() -> PackedStringArray:
    var warnings := PackedStringArray()
    if weapon == null:
        warnings.append("Missing SxFPSWeapon node")
    if hitbox == null:
        warnings.append("Missing Hitbox node")
    if collision_shape == null:
        warnings.append("Missing CollisionShape node")
    if camera == null:
        warnings.append("Missing Camera node")
    return warnings


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
            var motion_event := event as InputEventMouseMotion
            _mouse_delta = motion_event.relative

# func _physics_process_noclip(delta: float) -> void:
#     var look_sensitivity = SxCVars.get_cvar("SxFPSControllerLookSensitivity")
#     var speed := float(SxCVars.get_cvar("SxFPSControllerMoveSpeed"))
#     acceleration = Vector3.ZERO

#     var helper_rotation = _rotation_helper.rotation_degrees
#     helper_rotation.x -= _mouse_delta.y * look_sensitivity * delta
#     helper_rotation.x = clamp(helper_rotation.x, MIN_LOOK_ANGLE, MAX_LOOK_ANGLE)
#     helper_rotation.y -= _mouse_delta.x * look_sensitivity * delta
#     _rotation_helper.rotation_degrees = helper_rotation

#     var movement := _handle_movement()
#     var camera_xform := _camera.global_transform
#     var forward := global_transform.basis.z
#     var right := camera_xform.basis.x
#     var up := camera_xform.basis.y
#     var relative_dir := (forward * movement.z + right * movement.x + up * movement.z).normalized()
#     var move_velocity = relative_dir * speed

#     velocity = move_velocity
#     move_and_slide()
#     _physics_process_post()

func _physics_process(delta: float) -> void:
    var gravity = SxCVars.get_cvar("SxFPSControllerGravity") as int
    var look_sensitivity = SxCVars.get_cvar("SxFPSControllerLookSensitivity") as int
    var jump_speed = SxCVars.get_cvar("SxFPSControllerJumpSpeed") as int
    var max_ground_velocity = SxCVars.get_cvar("SxFPSControllerMaxGroundVelocity") as float
    var noclip = SxCVars.get_cvar("SxFPSControllerNoClip") as bool

    if _crouching:
        pass

    # Fire
    if _is_fire_pressed():
        weapon.fire()
    else:
        weapon.release()

    if noclip:
        collision_shape.disabled = true
    else:
        collision_shape.disabled = false

    if noclip:
        # _physics_process_noclip(delta)
        return

    # Reset acceleration
    _acceleration = Vector3.ZERO
    _acceleration += Vector3(0, gravity, 0) * delta;

    var on_floor = is_on_floor()

    if _inside_force_field:
        _acceleration = _force_field_amount

    # Jumping
    if _is_jump_pressed() && (_current_jumps + 1) < SxCVars.get_cvar("SxFPSControllerMaxJumps"):
        _jumping = true
        _current_jumps += 1
        _acceleration.y = -velocity.y + jump_speed

    if on_floor:
        _current_jumps = 0
        _jumping = false

    # Walking
    if on_floor && _is_walk_pressed():
        _walking = true
    else:
        _walking = false

    # Crouching
    if on_floor && _is_crouch_pressed():
        _crouching = true
        # _animation_player.play("crouch")
    else:
        _crouching = false
        # _animation_player.play("idle")

    # Peeking
    var peeking_dir = _handle_peeking()
    if peeking_dir != Vector3.ZERO:
        _peeking = true
        var dir := _handle_peeking()
        var forward := global_transform.basis.z
        var right := global_transform.basis.x
        _peek_rotation = lerp(_peek_rotation, deg_to_rad(-peeking_dir.x * 35), 0.1)
    else:
        _peeking = false
        _peek_rotation = lerp(_peek_rotation, 0.0, 0.1)

    # Apply peek
    rotation.z = _peek_rotation

    # Movement
    if on_floor:
        if !_peeking && !_jumping && !_inside_force_field:
            var movement := _handle_movement()
            if movement:
                _handle_dash()
                var camera_xform := camera.global_transform
                var forward = global_transform.basis.z
                var right := camera_xform.basis.x
                var relative_dir := (forward * movement.z + right * movement.x).normalized()
                var move_velocity = relative_dir * _get_movement_speed()
                _acceleration.x += move_velocity.x * delta
                _acceleration.z += move_velocity.z * delta
            elif !_dashing:
                _acceleration.x = -velocity.x * 0.5;
                _acceleration.z = -velocity.z * 0.5;
    else:
        # In air
        if !_inside_force_field:
            var movement := _handle_movement()
            if movement:
                var camera_xform := camera.global_transform
                var forward := camera_xform.basis.z
                var right := camera_xform.basis.x
                var relative_dir := (forward * movement.z + right * movement.x).normalized()
                var move_velocity = relative_dir * _get_movement_speed()
                _acceleration.x += move_velocity.x * delta
                _acceleration.z += move_velocity.z * delta

    velocity += _acceleration
    move_and_slide()

    for collision_idx in get_slide_collision_count():
        var collision := get_slide_collision(collision_idx)
        var collider := collision.get_collider()
        if collider is RigidBody3D:
            collider.apply_force(-collision.get_normal() * 10.0)

    if on_floor && !_dashing && !_inside_force_field:
        var an = Vector2(velocity.x, velocity.z).limit_length(max_ground_velocity)
        velocity.x = an.x
        velocity.z = an.y

    # Camera rotation
    var helper_rotation = _rotation_helper.rotation_degrees
    helper_rotation.x -= _mouse_delta.y * look_sensitivity * delta
    helper_rotation.x = clamp(helper_rotation.x, MIN_LOOK_ANGLE, MAX_LOOK_ANGLE)
    _rotation_helper.rotation_degrees = helper_rotation

    # Body rotation
    rotation_degrees.y -= _mouse_delta.x * look_sensitivity * delta

    _physics_process_post()

func _physics_process_post() -> void:
    _mouse_delta = Vector2()

    _force_field_amount = Vector3.ZERO

func _is_input_enabled() -> bool:
    return true

func _on_hitbox_entered(area: Area3D) -> void:
    pass

func _handle_movement() -> Vector3:
    var movement := Vector3()
    if !_is_input_enabled():
        return movement

    if _is_action_pressed(move_left_action):
        movement.x -= 1
    if _is_action_pressed(move_right_action):
        movement.x += 1
    if _is_action_pressed(move_forward_action):
        movement.z -= 1
    if _is_action_pressed(move_backward_action):
        movement.z += 1

    return movement.normalized()

func _handle_dash() -> void:
    if _is_action_just_pressed(move_left_action):
        _handle_dash_i("left")
    if _is_action_just_pressed(move_right_action):
        _handle_dash_i("right")
    if _is_action_just_pressed(move_forward_action):
        _handle_dash_i("forward")
    if _is_action_just_pressed(move_backward_action):
        _handle_dash_i("backward")

func _handle_dash_i(action: String) -> void:
    var threshold = SxCVars.get_cvar("SxFPSControllerDashThreshold")
    var now_time = Time.get_ticks_msec()
    if _prev_movement_action == action && _prev_movement_time && now_time - _prev_movement_time < threshold:
        _dashing = true
        _dash_timer.start()
    else:
        _dash_timer.stop()
        _dashing = false
    _prev_movement_action = action
    _prev_movement_time = now_time

func _handle_peeking() -> Vector3:
    var peek_direction := Vector3.ZERO

    if _is_action_pressed(peek_left_action):
        peek_direction.x -= 1
    if _is_action_pressed(peek_right_action):
        peek_direction.x += 1

    return peek_direction.normalized()

func _apply_force_field(force: Vector3) -> void:
    _inside_force_field = true
    _force_field_amount = force

    # Reset velocity & accel
    velocity = Vector3.ZERO
    _acceleration = Vector3.ZERO

    if !_force_field_timer.is_stopped():
        _force_field_timer.stop()
    _force_field_timer.start()

func _fire_pressed() -> void:
    pass

func _get_movement_speed() -> float:
    if !is_on_floor():
        return float(SxCVars.get_cvar("SxFPSControllerAirMoveSpeed"))
    elif _dashing:
        return float(SxCVars.get_cvar("SxFPSControllerDashSpeed"))
    elif _crouching:
        return float(SxCVars.get_cvar("SxFPSControllerCrouchSpeed"))
    elif _walking:
        return float(SxCVars.get_cvar("SxFPSControllerWalkSpeed"))
    else:
        return float(SxCVars.get_cvar("SxFPSControllerMoveSpeed"))

func _is_action_pressed(action: String) -> bool:
    if !action:
        return false
    return SxInput.is_action_pressed(action)

func _is_action_just_pressed(action: String) -> bool:
    if !action:
        return false
    return SxInput.is_action_just_pressed(action)

func _is_jump_pressed() -> bool:
    if !_is_input_enabled():
        return false
    return _is_action_just_pressed(jump_action)

func _is_crouch_pressed() -> bool:
    if !_is_input_enabled():
        return false
    return _is_action_pressed(crouch_action)

func _is_walk_pressed() -> bool:
    if !_is_input_enabled():
        return false
    return _is_action_pressed(walk_action)

func _is_fire_pressed() -> bool:
    if !_is_input_enabled():
        return false
    return _is_action_pressed(fire_action)
