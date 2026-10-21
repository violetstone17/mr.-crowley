extends "res://scenes/Items/door.tscn"

func checkDoor(b: Node2D) -> void:
	if b.is_in_group("player") and GameState.hasDungeonKey:
		open()
