class_name PickUp
extends Node3D

@export var config: PickUpConfig
@export var interact: GUIDEAction

var raycast: RayCast3D
var hud: PlayerHud

var held: Held
var hand: Vector3:
	get ():
		return global_position + global_transform.basis * Vector3.FORWARD * config.pickup_length


func _ready() -> void:
	raycast = RayCast3D.new()
	raycast.collision_mask = 4
	raycast.target_position = Vector3.FORWARD * config.pickup_length
	add_child(raycast)

	hud = Globals.player.hud

	interact.triggered.connect(_on_interact_triggered)


func _physics_process(delta: float) -> void:
	_color_cross()
	_move_held(delta)


func _on_interact_triggered() -> void:
	print("triggered pick up")
	if held:
		held.body.linear_damp = 1
		held = null
	elif raycast.is_colliding():
		var item = raycast.get_collider() as RigidBody3D
		item.linear_damp = 1
		held = Held.new(item, raycast.get_collision_point() - item.global_position)
		print("picked up")
	return


func _move_held(delta: float) -> void:
	if !held:
		return
	var x = held.body.global_position - hand
	var spring = hand - global_position
	var diff = -x.dot(spring)
	held.body.apply_force(diff * x.normalized() * config.pickup_strength * delta, held.offset)
	held.body.apply_force(Vector3.UP * held.body.mass * 9.81)


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
