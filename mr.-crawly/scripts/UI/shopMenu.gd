extends CanvasLayer

@onready var infoLabel: Label = %HealthInfo
@onready var buyButton: Button = %BuyHealthButton
@onready var closeButton: Button = %CloseButton

func _ready() -> void:
	visible = false
	buyButton.pressed.connect(onBuyPressed)
	closeButton.pressed.connect(close)
	GameState.coinsChanged.connect(refresh)
	GameState.upgradesChanged.connect(refresh)
	refresh()

func refresh(_unused = null) -> void:
	var cost = GameState.getHealthUpgradeCost()
	var level = GameState.upgradeHealth
	var gain = GameState.getHealthBonus(level + 1) - GameState.getHealthBonus(level)
	infoLabel.text = "Max Health Lv {0} (+{1} per level)".format([level, gain])
	buyButton.text = "Buy: {0} coins".format([cost])
	buyButton.disabled = GameState.coins < cost
	
func onBuyPressed() -> void:
	GameState.tryBuyHealthUpgrade()

func open() -> void:
	visible = true
	get_tree().paused = true
	buyButton.grab_focus()

func close() -> void:
	visible = false
	get_tree().paused = false

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("back"):
		close()
