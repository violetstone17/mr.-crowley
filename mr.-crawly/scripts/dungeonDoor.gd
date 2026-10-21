extends "res://scripts/items/door.gd"

func checkDoor(b: Node2D) -> void:
	if b.is_in_group("player") and GameState.hasDungeonKey:
		open()
