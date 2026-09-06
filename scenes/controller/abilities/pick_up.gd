@tool
class_name PickUp
extends Node3D

@export var config: PickUpConfig
@export var interact: GUIDEAction

var raycast: RayCast3D

@onready var arm: RigidSpringArm3D = $RigidSpringArm3D
@onready var holder: RigidSpringArm3D = $RigidBody3D/RigidSpringArm3D


func _ready() -> void:
	raycast = RayCast3D.new()
	raycast.collision_mask = 4
	raycast.target_position = Vector3.FORWARD * config.pickup_length
	add_child(raycast)
	config.changed.connect(config_changed)


func _physics_process(_delta: float) -> void:
	if interact.is_triggered():
		print("triggered pick up")
		var held = find_holding()
		if held:
			holder.target = null
		elif raycast.is_colliding():
			var item = raycast.get_collider() as Node3D
			holder.target = item
			print("picked up")
		return
	if raycast.is_colliding():
		# add material
		pass


func find_holding() -> RigidBody3D:
	return holder.target


func config_changed() -> void:
	arm.arrow.lenght = config.pickup_length
	arm.k = config.pickup_strength
	arm.target.global_position = arm.arrow.global_position - arm.arrow.direction()
	holder.k = config.pickup_strength
