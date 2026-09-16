@tool
class_name PickUpConfig extends Resource

@export var pickup_length: float = 3.0:
    set(value):
        pickup_length = value
        emit_changed()
## How many oscillations per second the arm settles at. Stiffness is derived
## from this and the held mass, so heavy objects anchor you and light ones do
## not. Much above 3 goes unstable at a 60 Hz tick.
@export var pickup_strength: float = 2.0:
    set(value):
        pickup_strength = value
        emit_changed()