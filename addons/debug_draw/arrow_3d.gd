@tool
class_name Arrow3D
extends DebugGeometry

@export var length: float = 1:
    set(value):
        length = value
        if !_is_ready():
            return
        head.position.z = -(length - 0.25 / 2.0)
        body.mesh.height = length - 0.25
        body.position.z = -(length - 0.25) / 2.0

var head_mesh = preload("res://addons/debug_draw/arrow_head.tres")
var body_mesh = preload("res://addons/debug_draw/arrow_body.tres")

var head: MeshInstance3D
var body: MeshInstance3D
var material = StandardMaterial3D.new()


func _ready() -> void:
    if !Engine.is_editor_hint() and debug_only:
        return

    head = MeshInstance3D.new()
    head.mesh = head_mesh.duplicate()
    head.position.z = -0.875
    head.rotate_x(-PI / 2)
    body = MeshInstance3D.new()
    body.mesh = body_mesh.duplicate()
    body.position.z = -0.375
    body.rotate_x(-PI / 2)
    add_child(head)
    add_child(body)
    length = length
    material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    head.set_surface_override_material(0, material)
    body.set_surface_override_material(0, material)
    _meshes.append_array([head, body])


func direction() -> Vector3:
    return global_transform.basis * Vector3.FORWARD * length
