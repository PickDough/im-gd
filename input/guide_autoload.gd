extends Node


func _ready() -> void:
    var context = load("res://input/main_guide_context.tres")
    GUIDE.enable_mapping_context(context)
