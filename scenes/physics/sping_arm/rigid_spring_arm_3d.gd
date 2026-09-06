class_name RigidSpringArm3D extends Node3D

@export var k: float = 2.0

@export var target: RigidBody3D
@export var arrow: Arrow3D

func _physics_process(delta: float) -> void:
	if !target:
		return
	var curr_direction = target.global_position - global_position
	var diff = arrow.direction().dot(curr_direction)
	var x = arrow.lenght - diff
	
	target.apply_central_force(arrow.direction().normalized() * x * k * delta)
