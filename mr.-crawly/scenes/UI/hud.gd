extends CanvasLayer

@onready var coinLabel: Label = %CoinLabel
@onready var healthLabel: Label = %HealthLabel
var healthFormat: String = "Health: {0} / {1}"
var coinsFormat: String = "Coins: {0}"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coinLabel.text = coinsFormat.format([GameState.coins])
	healthLabel.text = healthFormat.format([GameState.currentHealth, GameState.maxHealth])
	GameState.coinsChanged.connect(coinUpdate)
	GameState.healthChanged.connect(healthChanged)
	GameState.coins += 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("addCoinsDebug"):
		GameState.coins += 10
	

func healthChanged(newAmount):
	healthLabel.text = healthFormat.format([newAmount, GameState.maxHealth])

func coinUpdate(newAmount):
	coinLabel.text = str("Coins: ", newAmount)
	
