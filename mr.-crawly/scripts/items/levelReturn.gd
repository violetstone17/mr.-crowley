extends "res://scripts/items/door.gd"

@export var targetLevel: PackedScene

func checkDoor(body: Node2D) -> void:
	if body.is_in_group("player") and targetLevel != null:
		get_tree().change_scene_to_packed(targetLevel)
