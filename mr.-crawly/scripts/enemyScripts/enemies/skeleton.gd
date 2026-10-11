extends EnemyBase

@export var riseTime: float = 1.0

func _ready() -> void:
	super()
	state = State.RISE
	_startRise()

func _startRise() -> void:
	# graybox visual: swap "$Sprite" for your actual node
	# $Sprite.position.y = 24
	# create_tween().tween_property($Sprite, "position:y", 0, riseTime)
	await get_tree().create_timer(riseTime).timeout
	if not is_inside_tree() or state != State.RISE:
		return
	# the detection area may have already spotted the player while rising
	changeState(State.CHASE if player else State.PATROL)

func _updateBehavior(delta: float) -> void:
	match state:
		State.RISE:
			pass
		State.PATROL:
			if player:
				changeState(State.CHASE)
		State.CHASE:
			if not player:
				changeState(State.PATROL)
				return
			chase()
			if playerInRange and attackCooldown == 0.0:
				attack()
