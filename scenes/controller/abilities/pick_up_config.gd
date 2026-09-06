@tool
class_name PickUpConfig extends Resource

@export var pickup_length: float = 3.0:
	set(value):
		pickup_length = value
		emit_changed()
@export var pickup_strength: float = 100.0:
	set(value):
		pickup_strength = value
		emit_changed()
