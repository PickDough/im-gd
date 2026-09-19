extends Node

var collection: Collection = Collection.new()


func arrow(pos: Vector3, at: Vector3, color = Color.WHITE, alpha = 0.75) -> void:
    var arrow: Arrow3D = collection.get_geometry(_id(), DebugGeometry.Geometry.Arrow).geometry
    arrow.position = pos
    arrow.length = (at - pos).length()
    arrow.look_at(at)
    color.a = alpha
    arrow.color = color


func sphere(pos: Vector3, color = Color.WHITE, alpha = 0.75) -> void:
    var sphere: Sphere3D = collection.get_geometry(_id(), DebugGeometry.Geometry.Sphere).geometry
    sphere.global_position = pos
    color.a = alpha
    sphere.color = color


func _id() -> String:
    var caller = get_stack()[2]
    return caller['function'] + str(caller['line'])


class Obj:
    func _init(geo: DebugGeometry.Geometry):
        match geo:
            DebugGeometry.Geometry.Arrow:
                var a = Arrow3D.new()
                a.debug_only = false
                geometry = a
            DebugGeometry.Geometry.Sphere:
                var s = Sphere3D.new()
                s.debug_only = false
                geometry = s
        last_used = Timer.new()
        last_used.wait_time = 0.5
        geometry.add_child(last_used)


    var geometry: Node3D
    var last_used: Timer


class Collection:
    func get_geometry(id: String, geo: DebugGeometry.Geometry) -> Obj:
        if !dict.has(id):
            var obj = Obj.new(geo)
            obj.last_used.timeout.connect(
                func():
                    obj.geometry.queue_free()
                    dict.erase(id),
            )
            DeDraw.add_child(obj.geometry)
            dict[id] = obj

        dict[id].last_used.start()
        return dict[id]


    var dict: Dictionary = { }
