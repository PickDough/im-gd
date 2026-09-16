class_name PickUp
extends Node3D

@export var config: PickUpConfig
@export var interact: GUIDEAction

var raycast: RayCast3D
var hud: PlayerHud
var held: RigidBody3D:
    get():
        return horizontal.target
    set(value):
        horizontal.target = value

@onready var horizontal: DoublySpringArm3D = $HorizontalArm


func _ready() -> void:
    config_changed()

    raycast = RayCast3D.new()
    raycast.collision_mask = 4
    raycast.target_position = Vector3.FORWARD * config.pickup_length
    add_child(raycast)

    hud = Globals.player.hud

    interact.triggered.connect(_on_interact_triggered)

func _physics_process(_delta: float) -> void:
    _color_cross()
    

func _on_interact_triggered() -> void:
    print("triggered pick up")
    if held:
        held = null
    elif raycast.is_colliding():
        var item = raycast.get_collider() as Node3D
        held = item
        print("picked up")
    return


func config_changed() -> void:
    horizontal.arrow.length = config.pickup_length
    horizontal.k = config.pickup_strength
    horizontal.other_target = Globals.player.pawn
    horizontal.other_target.global_position = horizontal.arrow.global_position - horizontal \
            .arrow \
            .direction()


func _color_cross():
    if held:
        hud.set_cross_color(Color.YELLOW)
        return
    if raycast.is_colliding():
        hud.set_cross_color(Color.FIREBRICK)
    else:
        hud.reset_cross_color()
