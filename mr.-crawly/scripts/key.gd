extends Node2D

signal keyPickedUp

@onready var detector: Area2D = $Area2D
@onready var detectionShape: CollisionShape2D = $Area2D/CollisionShape2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detectionShape.set_deferred('disabled', true)
	detector.body_entered.connect(checkKey)
	print("timer going...")
	await get_tree().create_timer(5.0)
	print("timer done!")
	detectionShape.set_deferred('disabled', false)

func checkKey(b: Node2D) -> void:
	if b.is_in_group("player"):
		pickup()

func pickup() -> void:
	print("player picked up the key!")
	GameState.hasDungeonKey = true
	keyPickedUp.emit()
	queue_free()
