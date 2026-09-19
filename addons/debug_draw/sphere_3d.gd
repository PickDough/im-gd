@tool
class_name Sphere3D
extends DebugGeometry

@export var radius = 1.0:
    set(value):
        radius = value
        if !_is_ready():
            return
        mesh.mesh.radius = radius
        mesh.mesh.height = 2 * radius

var material = StandardMaterial3D.new()
var mesh: MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    var mesh = MeshInstance3D.new()
    mesh.mesh = SphereMesh.new()
    material.resource_local_to_scene = true
    mesh.set_surface_override_material(0, material)
    add_child(mesh)
    _meshes.append(mesh)
