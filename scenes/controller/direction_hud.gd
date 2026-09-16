extends Node2D

var body: RigidPawn


func _ready() -> void:
    body = Globals.player.pawn
    body.force_applied.connect(
        func(force: Vector3):
            var dir = body.transform * force
            rotation = Vector2(dir.x, dir.z).angle(),
    )
