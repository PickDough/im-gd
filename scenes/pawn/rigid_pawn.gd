class_name RigidPawn
extends RigidBody3D

var body_state: PawnIntent.BodyState = PawnIntent.BodyState.STAND
var intent: PawnIntent = PawnIntent.new()
@export var config: PawnConfig

## How long a jump press stays queued while airborne. Without a timeout the
## press latches until the next landing, which reads as a double jump.
const JUMP_BUFFER_TIME := 0.1

var _floor_ray: RayCast3D
var _yaw_delta := 0.0
var _jump_buffer := 0.0

func head() -> Node3D:
	return $Head

func add_look_yaw(radians: float) -> void:
	_yaw_delta += radians

func _ready() -> void:
	_floor_ray = RayCast3D.new()
	_floor_ray.exclude_parent = true
	add_child(_floor_ray)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if is_zero_approx(_yaw_delta):
		return
	var xform := state.transform
	xform.basis = xform.basis.rotated(Vector3.UP, _yaw_delta).orthonormalized()
	state.transform = xform
	_yaw_delta = 0.0

func _physics_process(delta: float) -> void:
	var shape := $CollisionShape3D.shape as BoxShape3D
	_floor_ray.target_position = Vector3(0.0, -shape.size.y * 0.5 - 0.08, 0.0)
	var on_floor := _floor_ray.is_colliding()

	var wish := global_transform.basis * intent.movement
	wish.y = 0.0
	var moving := not wish.is_zero_approx()
	if moving:
		wish = wish.normalized()

	var rate := 0.0
	if moving:
		rate = config.acceleration if on_floor else config.air_acceleration
	elif on_floor:
		rate = config.deceleration

	if rate > 0.0:
		var target := wish * _max_speed()
		var current := Vector3(linear_velocity.x, 0.0, linear_velocity.z)
		# Force that lands exactly on target this step, capped at rate. The cap
		# keeps push strength at mass * rate when something blocks us; the taper
		# stops the overshoot jitter a constant force produces near the target.
		var needed := (target - current) * mass / delta
		apply_central_force(needed.limit_length(rate * mass))

	if intent.jump:
		_jump_buffer = JUMP_BUFFER_TIME
		intent.jump = false
	_jump_buffer = maxf(_jump_buffer - delta, 0.0)

	if on_floor and _jump_buffer > 0.0:
		apply_central_impulse(Vector3.UP * mass * (config.jump_height - linear_velocity.y))
		_jump_buffer = 0.0

	if intent.crouch:
		_crouch()
		intent.crouch = false

func _max_speed() -> float:
	if body_state == PawnIntent.BodyState.CROUCH || body_state == PawnIntent.BodyState.CROUCHING:
		return config.crouch_speed
	return config.sprint_speed if intent.sprint else config.walk_speed

func _crouch() -> void:
	match body_state:
		PawnIntent.BodyState.CROUCHING:
			return
		PawnIntent.BodyState.CROUCH:
			var tween = create_tween()
			tween.tween_property($CollisionShape3D, "shape:size:y", config.stand_height, config.crouch_time)
			tween.tween_callback(func(): body_state = PawnIntent.BodyState.STAND)
		PawnIntent.BodyState.STAND:
			var tween = create_tween()
			tween.tween_property($CollisionShape3D, "shape:size:y", config.crouch_height, config.crouch_time)
			tween.tween_callback(func(): body_state = PawnIntent.BodyState.CROUCH)
