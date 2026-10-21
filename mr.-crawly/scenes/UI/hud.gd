extends CanvasLayer

@onready var coinLabel: Label = %CoinLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.coinsChanged.connect(coinUpdate)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func coinUpdate():
	pass
