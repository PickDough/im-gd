class_name DebugGeometry
extends Node3D

enum Geometry {
    Arrow,
    Sphere,
}

@export var debug_only: bool = true
@export var color: Color:
    set(value):
        color = value
        if !_is_ready():
            return
        for m in _meshes:
            var mm = m.get_active_material(0) as StandardMaterial3D
            mm.albedo_color = color

var _r: bool
var _meshes: Array[MeshInstance3D] = []


func _enter_tree() -> void:
    ready.connect(
        func():
            _r = true
            set("color", color),
    )


func _is_ready() -> bool:
    return _r and (Engine.is_editor_hint() or !debug_only)
