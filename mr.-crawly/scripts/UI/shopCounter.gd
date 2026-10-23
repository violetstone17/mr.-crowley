extends Area2D

@onready var shopMenu = $"../ShopMenu"
var playerInside := false

func _ready() -> void:
	body_entered.connect(onBodyEntered)
	body_exited.connect(onBodyExited)
	
func onBodyEntered(b: Node2D):
	if b.is_in_group("player"):
		playerInside = true

func onBodyExited(b: Node2D):
	if b.is_in_group("player"):
		playerInside = false

func _unhandled_input(event: InputEvent) -> void:
	if playerInside and event.is_action_pressed("interact"):
		shopMenu.open()
