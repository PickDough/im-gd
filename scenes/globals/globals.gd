@tool
class_name Global
extends Node

var player: PlayerController:
    get ():
        if Engine.is_editor_hint():
            return
        if !player:
            player = get_tree().root.find_child("PlayerController", true, false)
        return player


static func G(node: Node) -> Global:
    return node.get_node("/root/Globals")
