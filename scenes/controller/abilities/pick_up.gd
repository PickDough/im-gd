class_name PickUp
extends Node3D

@export var config: PickUpConfig
@export var interact: GUIDEAction
@export var catch_up_time := 0.2
@export var max_catch_speed := 7.0
@export var gravity_comp := 1.0

var raycast: RayCast3D
var hud: PlayerHud
var pawn: RigidPawn
var held: Held
var prev_hand: Vector3

var hand: Vector3:
    get():
        return global_position + global_transform.basis * Vector3.FORWARD * config.pickup_length


func _ready() -> void:
    raycast = RayCast3D.new()
    raycast.collision_mask = 4
    raycast.target_position = Vector3.FORWARD * config.pickup_length
    add_child(raycast)
    hud = Globals.player.hud
    pawn = Globals.player.pawn
    interact.triggered.connect(_on_interact_triggered)
    prev_hand = hand


func _physics_process(delta: float) -> void:
    _color_cross()
    _move_held(delta)
    prev_hand = hand


func _on_interact_triggered() -> void:
    print("triggered pick up")
    if held:
        held.body.linear_damp = 0
        pawn.mass -= held.body.mass
        held = null
    elif raycast.is_colliding():
        var item := raycast.get_collider() as RigidBody3D
        if item == null:
            return
        held = Held.new(item, item.to_local(raycast.get_collision_point()))
        held.body.linear_damp = 4
        pawn.mass += held.body.mass
        print("picked up")


func _move_held(delta: float) -> void:
    if !held:
        return

    var grab_world: Vector3 = held.body.to_global(held.offset)
    var x: Vector3 = hand - grab_world

    var v_hand: Vector3 = (hand - prev_hand) / max(delta, 0.0001)
    var r: Vector3 = grab_world - held.body.global_position
    var v_grab: Vector3 = held.body.linear_velocity + held.body.angular_velocity.cross(r)

    var catch_v: Vector3 = x / catch_up_time
    if catch_v.length() > max_catch_speed:
        catch_v = catch_v.normalized() * max_catch_speed

    var force: Vector3 = held.body.mass * (v_hand + catch_v - v_grab) / max(delta, 0.0001)
    force += (
        Vector3.UP * gravity_comp * held.body.mass * 9.81
    ).limit_length(config.pickup_strength)
    force = force.limit_length(config.pickup_strength)

    DeDraw.sphere(hand, Color.GREEN_YELLOW)

    held.body.apply_force(force, r)
    var f_pawn := -force * 0.25
    f_pawn.y = minf(f_pawn.y, 0.0)
    pawn.apply_force(f_pawn, hand - pawn.global_position)


func _color_cross():
    if held:
        hud.set_cross_color(Color.YELLOW)
        return
    if raycast.is_colliding():
        hud.set_cross_color(Color.FIREBRICK)
    else:
        hud.reset_cross_color()


class Held:
    func _init(b: RigidBody3D, p: Vector3) -> void:
        body = b
        offset = p


    var body: RigidBody3D
    var offset: Vector3
