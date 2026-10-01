extends Node2D

signal doorOpened

@onready var detector: Area2D = $Area2D
@onready var body: StaticBody2D = $StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detector.body_entered.connect(checkDoor)

func checkDoor(b: Node2D) -> void:
	if b.is_in_group("player") and GameState.hasDungeonKey:
		open()

func open() -> void:
	doorOpened.emit()
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
