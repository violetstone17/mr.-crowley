extends EnemyBase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	maxHealth = 10
	speed = 100.0 + randf_range(0.0, 5.0)
	enemyStrength = 5
	#call to initalize everything together
	super()
