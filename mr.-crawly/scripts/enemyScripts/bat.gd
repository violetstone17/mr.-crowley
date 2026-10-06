extends "res://scripts/enemyScripts/enemyBase.gd"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	maxHealth = 10
	speed = 100.0 + randf_range(0.0, 5.0)
	enemyStrength = 5
	#call to initalize everything together
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		chase()
	else:
		pass

func chase():
	var target: Vector2 = player.global_position
	
	target += Vector2(randf_range(-20,20), randf_range(-20,20))
	velocity = (target - global_position).normalized() * speed
	move_and_slide()
