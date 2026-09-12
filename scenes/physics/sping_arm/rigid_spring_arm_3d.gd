class_name RigidSpringArm3D
extends Node3D

## Oscillations per second the arm settles at. Stiffness is derived from this
## and the held mass, so a heavy object anchors hard and a light one snaps to
## the rest position without the solver blowing up.
@export var frequency: float = 2.0
## 1.0 settles without overshoot. Below that the object bobs on the arm.
@export var damping_ratio: float = 1.0

@export var target: RigidBody3D
@export var arrow: Arrow3D


func _physics_process(_delta: float) -> void:
    if !target:
        return

    target.apply_central_force(_force(self, Vector3.ZERO, 0.0))


## Spring force along the arm, pulling `target` towards its rest position
## relative to `other`. `other_mass` of 0 treats the other end as immovable.
func _force(other: Node3D, other_velocity: Vector3, other_mass: float) -> Vector3:
    var axis := arrow.direction().normalized()
    # Reduced mass keeps the response critically damped for the pair, so the
    # tuning holds whether the far end is a pebble or a building.
    var m := target.mass
    if other_mass > 0.0:
        m = target.mass * other_mass / (target.mass + other_mass)
    var omega := TAU * frequency
    var k := m * omega * omega
    var damping := 2.0 * damping_ratio * m * omega
    var closing := (target.linear_velocity - other_velocity).dot(axis)
    return axis * (_x(other) * k - closing * damping)


func _x(other: Node3D) -> float:
    var curr_direction = target.global_position - other.global_position
    var diff = arrow.direction().normalized().dot(curr_direction)
    var x = arrow.length - diff
    return x
