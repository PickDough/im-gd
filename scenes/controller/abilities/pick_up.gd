@tool
class_name PickUp
extends Node3D

@export var config: PickUpConfig
@export var interact: GUIDEAction

var raycast: RayCast3D

@onready var horizontal: DoublySpringArm3D = $HorizontalArm


func _ready() -> void:
    raycast = RayCast3D.new()
    raycast.collision_mask = 4
    raycast.target_position = Vector3.FORWARD * 2 * config.pickup_length
    add_child(raycast)
    config.changed.connect(config_changed)
    config_changed()

    if Engine.is_editor_hint():
        return
    var body: RigidPawn = get_parent().get_parent()
    horizontal.other_target = body


func _physics_process(_delta: float) -> void:
    if interact.is_triggered():
        print("triggered pick up")
        var held = find_holding()
        if held:
            horizontal.target = null
        elif raycast.is_colliding():
            var item = raycast.get_collider() as Node3D
            horizontal.target = item
            print("picked up")
        return
    if raycast.is_colliding():
        # add material
        pass


func find_holding() -> RigidBody3D:
    return horizontal.target


func config_changed() -> void:
    horizontal.arrow.length = config.pickup_length
    horizontal.frequency = config.pickup_frequency
    horizontal.damping_ratio = config.pickup_damping_ratio
