class_name PawnConfig
extends Resource

@export var walk_speed = 5.0;
@export var sprint_speed = 8.0;
@export var crouch_speed = 3.0;
@export var jump_height = 2.0;
## Max ground push toward the target speed, in Newtons. External forces can
## still win; this is a budget, not a speed lock.
@export var strength = 1400.0
## Braking force with no input, and sideways grip while moving. Grounded only.
@export var brake_strength = 4200.0
## Steering force while airborne.
@export var air_strength = 700.0
@export var look_pitch = .05;
@export var look_yaw = .05;
@export var crouch_height = 1.0;
@export var crouch_time = 0.2;
@export var stand_height = 2.0;
