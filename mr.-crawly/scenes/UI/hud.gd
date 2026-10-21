extends CanvasLayer

@onready var coinLabel: Label = %CoinLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%CoinLabel.text = "Coins: 0"
	%HealthLabel.text = "Health: "
	GameState.coinsChanged.connect(coinUpdate)
	GameState.coins += 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func coinUpdate(newAmount):
	GameState.coins += newAmount
	coinLabel.text = str("Coins: ", GameState.coins)
	
