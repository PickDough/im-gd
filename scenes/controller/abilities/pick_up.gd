class_name PickUp
extends Node3D

@export var config: PickUpConfig
@export var interact: GUIDEAction

var raycast: RayCast3D
var hud: PlayerHud

var pawn: RigidPawn
var held: Held
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


func _physics_process(delta: float) -> void:
    _color_cross()
    _move_held(delta)


func _on_interact_triggered() -> void:
    print("triggered pick up")
    if held:
        held.body.linear_damp = 0
        pawn.mass -= held.body.mass
        held = null
    elif raycast.is_colliding():
        var item = raycast.get_collider() as RigidBody3D
        held = Held.new(item, raycast.get_collision_point() - item.global_position)
        held.body.linear_damp = 2
        pawn.mass += held.body.mass
        print("picked up")
    return


func _move_held(delta: float) -> void:
    if !held:
        return
    var x = held.body.global_position - hand
    var force = -x * config.pickup_strength * delta
    DeDraw.sphere(hand, Color.GREEN_YELLOW)
    DeDraw.arrow(
        held.body.global_position + held.offset,
        held.body.global_position + force.normalized(),
        Color.AQUA,
    )
    held.body.apply_force(force, Vector3.ZERO)
    held.body.apply_force(Vector3.UP * min((held.body.mass * 9.81), config.pickup_strength))


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
