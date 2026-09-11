class_name PlayerController
extends Node3D

@export var movement: GUIDEAction
@export var jump: GUIDEAction
@export var sprint: GUIDEAction
@export var crouch: GUIDEAction
@export var look: GUIDEAction

var pawn: RigidPawn
var camera: Camera3D


func _ready() -> void:
	pawn = get_parent()
	assert(pawn is RigidPawn, "Controller must be a child of RigidPawn")

	camera = Camera3D.new()
	pawn.head().add_child(camera)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	jump.just_triggered.connect(_on_jump)
	look.triggered.connect(_on_look)
	crouch.triggered.connect(_on_crouch)

func _physics_process(_delta: float) -> void:
	if movement.is_triggered():
		pawn.intent.movement = Vector3(movement.value_axis_2d.x, 0, movement.value_axis_2d.y)
	else:
		pawn.intent.movement = Vector3.ZERO
	pawn.intent.sprint = sprint.is_triggered()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event is InputEventMouseButton:
		var mouse = event as InputEventMouseButton
		if mouse.button_mask == MOUSE_BUTTON_MASK_LEFT:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_jump() -> void:
	pawn.intent.jump = true

func _on_look() -> void:
	var pitch = look.value_axis_2d.y * pawn.config.look_pitch
	var yaw = look.value_axis_2d.x * pawn.config.look_yaw
	pawn.add_look_yaw(yaw)
	pawn.head().rotate(Vector3.RIGHT, pitch)
	pawn.head().rotation.x = clamp(pawn.head().rotation.x, -PI * 0.75, PI * 0.75)

func _on_crouch() -> void:
	pawn.intent.crouch = true
