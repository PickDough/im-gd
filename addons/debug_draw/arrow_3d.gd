@tool
class_name Arrow3D extends Node3D

var head_mesh = preload("res://addons/debug_draw/arrow_head.tres")
var body_mesh = preload("res://addons/debug_draw/arrow_body.tres")

var head: MeshInstance3D
var body: MeshInstance3D

@export var debug_only: bool = true
@export var lenght: float = 1:
	set(value):
		lenght = value
		if !head or !body:
			return
		if !Engine.is_editor_hint() and debug_only:
			return
		head.position.z = lenght - 0.25 / 2.0
		body.mesh.height = lenght - 0.25
		body.position.z = (lenght - 0.25) / 2.0

@export_tool_button("Direction") var print_direction = func():
	print(direction())


func _ready() -> void:
	if !Engine.is_editor_hint() and debug_only:
		return

	head = MeshInstance3D.new()
	head.mesh = head_mesh.duplicate()
	head.position.z = 0.875
	head.rotate_x(PI / 2)
	body = MeshInstance3D.new()
	body.mesh = body_mesh.duplicate()
	body.position.z = 0.375
	body.rotate_x(PI / 2)
	add_child(head)
	add_child(body)


func direction() -> Vector3:
	return global_transform.basis * Vector3.FORWARD * lenght
