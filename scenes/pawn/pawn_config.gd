class_name PawnConfig
extends Resource

@export var walk_speed = 5.0;
@export var sprint_speed = 8.0;
@export var crouch_speed = 3.0;
@export var jump_height = 2.0;
@export var acceleration = 20.;
## Braking rate with no input. Only runs while grounded and unpressed,
## so raising it costs nothing in push strength.
@export var deceleration = 60.;
## Steering authority while airborne.
@export var air_acceleration = 10.;
@export var look_pitch = .05;
@export var look_yaw = .05;
@export var crouch_height = 1.0;
@export var crouch_time = 0.2;
@export var stand_height = 2.0;
