extends Node

enum Geometry {
    Arrow,
}

var collection: Collection = Collection.new()


func arrow(pos: Vector3, at: Vector3, color = Color.WHITE, alpha = 0.5) -> void:
    var caller = get_stack()[1]
    var id = caller['function'] + caller['line']
    var arrow: Arrow3D = collection.get_geometry(id, Geometry.Arrow).geometry
    arrow.position = pos
    arrow.look_at(at)
    color.a = alpha
    arrow.color = color

class Obj:
    func _init(geo: Geometry):
        match geo:
            Geometry.Arrow:
                var arrow = Arrow3D.new()
                arrow.debug_only = false
                geometry = arrow
        last_used = Timer.new()
        last_used.start(0.5)


    var geometry: Node3D
    var last_used: Timer


class Collection:
    func get_geometry(id: String, geo: Geometry) -> Obj:
        if !dict.has(id):
            var obj = Obj.new(geo)
            obj.last_used.timeout.connect(
                func():
                    obj.geometry.queue_free()
                    dict.erase(id),
            )

        dict[id].last_user.start()
        return dict[id]


    var dict: Dictionary = { }
