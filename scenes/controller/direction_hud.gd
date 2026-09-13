extends Node2D

var body: RigidPawn


func _ready() -> void:
    body = Globals.G(self).player.pawn
