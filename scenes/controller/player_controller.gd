class_name PlayerController
extends Node3D

@export var movement: GUIDEAction
@export var jump: GUIDEAction
@export var sprint: GUIDEAction
@export var crouch: GUIDEAction
@export var look: GUIDEAction

var pawn: RigidPawn
var camera: Camera3D

var hud: PlayerHud


func _enter_tree() -> void:
	hud = $CanvasLayer
	pawn = get_parent()
	camera = Camera3D.new()
	pawn.head().add_child(camera)


func _ready() -> void:
	assert(pawn is RigidPawn, "Controller must be a child of RigidPawn")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	jump.just_triggered.connect(_on_jump)
	look.triggered.connect(_on_look)
	crouch.triggered.connect(_on_crouch)
	sprint.triggered.connect(
		func():
			pawn.intent.sprint = true,
	)
	movement.triggered.connect(
		func():
			pawn.intent.movement = Vector3(movement.value_axis_2d.x, 0, movement.value_axis_2d.y),
	)


func _physics_process(_delta: float) -> void:
	(func():
		pawn.intent = PawnIntent.new()
	).call_deferred()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event is InputEventMouseButton:
		var mouse = event as InputEventMouseButton
		if mouse.button_mask == MOUSE_BUTTON_MASK_LEFT:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("slowmo"):
		Engine.time_scale = 0.33 if Engine.time_scale == 1.0 else 1.0


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
	
