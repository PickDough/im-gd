class_name PickUp
extends Node3D

@export var config: PickUpConfig
@export var interact: GUIDEAction

var body: RigidPawn
var raycast: RayCast3D
var held: RigidBody3D
var hud: PlayerHud

var _applied_force: Vector3


func _ready() -> void:
    raycast = RayCast3D.new()
    raycast.collision_mask = 4
    raycast.target_position = Vector3.FORWARD * 2 * config.pickup_length
    add_child(raycast)

    body = Global.G(self).player.pawn
    hud = Global.G(self).player.hud

    interact.triggered.connect(_on_interact)


func _physics_process(_delta: float) -> void:
    _color_cross()

    if held:
        held.apply_central_force(_applied_force)


func _on_interact() -> void:
    if held:
        body.mass -= held.mass
        body.force_applied.disconnect(_on_force_applied)
        held = null
    elif raycast.is_colliding():
        held = raycast.get_collider() as RigidBody3D
        body.mass += held.mass
        body.force_applied.connect(_on_force_applied)


func _on_force_applied(force) -> void:
    _applied_force = force


func _color_cross():
    if held:
        hud.set_cross_color(Color.YELLOW)
        return
    if raycast.is_colliding():
        hud.set_cross_color(Color.FIREBRICK)
    else:
        hud.reset_cross_color()
