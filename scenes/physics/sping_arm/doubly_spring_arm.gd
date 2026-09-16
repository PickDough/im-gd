class_name DoublySpringArm3D
extends RigidSpringArm3D

@export var other_target: RigidBody3D


func _physics_process(_delta: float) -> void:
    if !target or !other_target:
        return

    var force = arrow.direction().normalized() * _x(self) * k
    target.apply_central_force(force)
    other_target.apply_central_force(-force)
