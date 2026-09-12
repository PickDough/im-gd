class_name DoublySpringArm3D
extends RigidSpringArm3D

@export var other_target: RigidBody3D


func _physics_process(_delta: float) -> void:
    if !target or !other_target:
        return

    var force = _force(other_target, other_target.linear_velocity, other_target.mass)
    target.apply_central_force(force)
    other_target.apply_central_force(-force)
