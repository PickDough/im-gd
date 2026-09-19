class_name PlayerHud
extends CanvasLayer

@onready var _cross: ColorRect = $ColorRect


func set_cross_color(color: Color) -> void:
	_cross.color = color


func reset_cross_color() -> void:
	_cross.color = Color.WHITE
