extends EnemyBase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = 100.0 + randf_range(-10.0, 10.0)
	enemyStrength = 5
	#call to initalize everything together
	super()
