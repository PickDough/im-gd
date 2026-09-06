class_name PawnIntent
extends Resource

var movement: Vector3
var jump: bool
var sprint: bool
var crouch: bool

enum BodyState {
	STAND,
	CROUCHING,
	CROUCH,
}
