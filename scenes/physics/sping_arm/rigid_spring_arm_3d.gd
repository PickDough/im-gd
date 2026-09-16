class_name RigidSpringArm3D
extends Node3D

@export var k: float = 2.0

@export var target: RigidBody3D
@export var arrow: Arrow3D


func _physics_process(_delta: float) -> void:
    if !target:
        return

    target.apply_central_force(arrow.direction().normalized() * _x(self) * k)


func _x(other: Node3D) -> float:
    var curr_direction = target.global_position - other.global_position
    var diff = arrow.direction().normalized().dot(curr_direction)
    var x = arrow.length - diff
    return x
