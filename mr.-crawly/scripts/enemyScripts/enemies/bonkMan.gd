extends EnemyBase

const KEY_SCENE := preload("res://scenes/Items/key.tscn")

@export var windupTime: float = 0.7
@export var recoverTime: float = 1.0
var stateTimer: float = 0.0

func _ready() -> void:
	enemyName = "levelBoss"
	super()

func _updateBehavior(d: float) -> void:
	stateTimer = max(0.0, stateTimer - d)
	match state:
		State.PATROL:
			if player:
				changeState(State.CHASE)
		State.CHASE:
			if not player:
				changeState(State.PATROL)
				return
			chase()
		State.WINDUP:
			if stateTimer == 0.0:
				_slam()
		State.RECOVER:
			if stateTimer == 0.0:
				changeState(State.CHASE)


func _startWindup() -> void:
	changeState(State.WINDUP)
	stateTimer = windupTime
	$BonkMan.modulate = Color.RED

func _slam() -> void:
	$BonkMan.modulate = Color.DARK_RED
	attack()
	changeState(State.RECOVER)

func die() -> void:
	var key := KEY_SCENE.instantiate()
	key.global_position = global_position
	get_parent().add_child.call_deferred(key)
	super()
