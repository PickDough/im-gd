@tool
class_name PickUp
extends Node3D

@export var config: PickUpConfig
@export var interact: GUIDEAction

var raycast: RayCast3D

@onready var horizontal: DoublySpringArm3D = $HorizontalArm
@onready var vertical: DoublySpringArm3D = $Knee/VerticalArm


func _ready() -> void:
    raycast = RayCast3D.new()
    raycast.collision_mask = 4
    raycast.target_position = Vector3.FORWARD * config.pickup_length
    add_child(raycast)
    config.changed.connect(config_changed)

    if Engine.is_editor_hint():
        return
    var body = get_parent().get_parent()
    horizontal.other_target = body


func _physics_process(_delta: float) -> void:
    if interact.is_triggered():
        print("triggered pick up")
        var held = find_holding()
        if held:
            vertical.target = null
        elif raycast.is_colliding():
            var item = raycast.get_collider() as Node3D
            vertical.target = item
            print("picked up")
        return
    if raycast.is_colliding():
        # add material
        pass


func find_holding() -> RigidBody3D:
    return vertical.target


func config_changed() -> void:
    horizontal.arrow.length = config.pickup_length
    horizontal.k = config.pickup_strength
    horizontal.target.global_position = horizontal.arrow.global_position - horizontal \
            .arrow \
            .direction()
    vertical.k = config.pickup_strength
