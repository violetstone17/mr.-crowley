extends "res://scripts/items/door.gd"

# Stored as a path (not a PackedScene) so two scenes can point at each other
# without creating a cyclic resource reference.
@export_file("*.tscn") var targetLevelPath: String

func checkDoor(body: Node2D) -> void:
	if body.is_in_group("player") and targetLevelPath != "":
		get_tree().call_deferred("change_scene_to_file", targetLevelPath)
