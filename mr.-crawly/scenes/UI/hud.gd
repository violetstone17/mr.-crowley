extends CanvasLayer

@onready var coinLabel: Label = %CoinLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%CoinLabel.text = str("Coins:  + {GameState.coins}")
	%HealthLabel.text = "Health: "
	GameState.coinsChanged.connect(coinUpdate)
	GameState.coins += 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("addCoinsDebug"):
		GameState.coins += 10
	


func coinUpdate(newAmount):
	coinLabel.text = str("Coins: ", newAmount)
	
