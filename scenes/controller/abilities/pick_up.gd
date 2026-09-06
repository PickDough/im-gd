class_name PickUp extends Node3D

var raycast: RayCast3D

@export var config: PickUpConfig
@export var interact: GUIDEAction

func _ready() -> void:
	assert(get_parent() is RigidPawn, "Parent must be Pawn")
	raycast = RayCast3D.new()
	raycast.collision_mask = 4
	raycast.target_position = Vector3.FORWARD * config.pickup_length
	get_parent().head().add_child(raycast)

func _physics_process(_delta: float) -> void:
	if interact.is_triggered():
		var held = find_holding()
		if held:
			held.queue_free()
		elif raycast.is_colliding():
			var item = raycast.get_collider() as Node3D
			held = Holding.new()
			held.item = item
			add_child(held)
		return
	if raycast.is_colliding():
		# add material
		pass
		
func find_holding() -> Holding:
	return find_child("Holding", false)
