class_name RigidPawn
extends RigidBody3D

signal force_applied(Vector3)
signal impulse_applied(Vector3)

@export var config: PawnConfig

var body_state: PawnIntent.BodyState = PawnIntent.BodyState.STAND
var intent: PawnIntent = PawnIntent.new()

var _floor_ray: RayCast3D
var _yaw_delta := 0.0
var _jump_buffer := 0.0


func _ready() -> void:
    _floor_ray = RayCast3D.new()
    _floor_ray.exclude_parent = true
    add_child(_floor_ray)


func _physics_process(delta: float) -> void:
    var shape := $CollisionShape3D.shape as BoxShape3D
    _floor_ray.target_position = Vector3(0.0, -shape.size.y * 0.5 - 0.08, 0.0)
    var on_floor := _floor_ray.is_colliding()

    var wish := global_transform.basis * intent.movement
    wish.y = 0.0
    var moving := not wish.is_zero_approx()
    if moving:
        wish = wish.normalized()

    var current := Vector3(linear_velocity.x, 0.0, linear_velocity.z)
    print(current.length())
    var force := Vector3.ZERO
    if moving:
        var budget: float = config.strength if on_floor else config.air_strength
        var along := current.dot(wish)
        force = _along_force(current, wish, budget, delta)
        if on_floor:
            # Feet resist sliding sideways. Along-wish only measures speed on
            # the input axis, so without this, turning banks the old heading
            # onto an axis it cannot see and circling accelerates forever.
            force += _friction(current - wish * along, delta)
    elif on_floor:
        force = _friction(current, delta)
    apply_central_force(force)
    force_applied.emit(force)

    if on_floor and intent.jump:
        var impulse = Vector3.UP * mass * (config.jump_height - linear_velocity.y)
        apply_central_impulse(impulse)
        impulse_applied.emit(impulse)

    if intent.crouch:
        _crouch()


func head() -> Node3D:
    return $Head


func add_look_yaw(radians: float) -> void:
    _yaw_delta += radians


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
    if is_zero_approx(_yaw_delta):
        return
    var xform := state.transform
    xform.basis = xform.basis.rotated(Vector3.UP, _yaw_delta).orthonormalized()
    state.transform = xform
    _yaw_delta = 0.0


## Force along `wish` that would match the target speed this step, clamped to
## `budget`. Overspeed reverses the push instead of ignoring it.
func _along_force(current: Vector3, wish: Vector3, budget: float, delta: float) -> Vector3:
    var needed := (_max_speed() - current.dot(wish)) * mass / delta
    return wish * clampf(needed, -budget, budget)


## Ground friction opposing `velocity`, trimmed so one step can bring it to rest
## but never drag it backwards through zero.
func _friction(velocity: Vector3, delta: float) -> Vector3:
    var speed := velocity.length()
    if is_zero_approx(speed):
        return Vector3.ZERO
    var to_rest := speed * mass / delta
    return (-velocity / speed * config.brake_strength).limit_length(to_rest)


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
            tween.tween_property(
                $CollisionShape3D,
                "shape:size:y",
                config.stand_height,
                config.crouch_time,
            )
            tween.tween_callback(
                func():
                    body_state = PawnIntent.BodyState.STAND,
            )
        PawnIntent.BodyState.STAND:
            var tween = create_tween()
            tween.tween_property(
                $CollisionShape3D,
                "shape:size:y",
                config.crouch_height,
                config.crouch_time,
            )
            tween.tween_callback(
                func():
                    body_state = PawnIntent.BodyState.CROUCH,
            )
