@tool
extends Node

var player: PlayerController:
	get():
		if Engine.is_editor_hint():
			return
		if !player:
			player = get_tree().root.find_child("PlayerController", true, false)
		return player
