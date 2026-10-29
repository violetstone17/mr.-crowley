extends Node


signal coinsChanged(newAmount)
signal healthChanged(newAmount)


#for player tracking/ position data
var playerRef: Node2D = null

#Run state
var coins: int = 0:
	set(value):
		coins = value
		coinsChanged.emit(coins)

var maxHealth: int = 0

var currentHealth: int = 0:
	set(value):
		currentHealth = value
		healthChanged.emit(currentHealth)

var hasDungeonKey: bool = false
var dungeonCleared: bool = false


# ---- SHOP UPGRADES/ LOGIC BELOW ----

signal upgradesChanged

const HEALTH_UPGRADE_BASE_COST := 50
const HEALTH_COST_CURVE := 5
const HEALTH_BONUS_SCALE := 30

var upgradeHealth: int = 0

func getHealthUpgradeCost() -> int:
	return HEALTH_UPGRADE_BASE_COST + HEALTH_COST_CURVE * upgradeHealth * upgradeHealth

func getHealthBonus(level: int) -> int:
	return roundi(HEALTH_BONUS_SCALE * log(0.8 + level))

func tryBuyHealthUpgrade() -> bool:
	var cost := getHealthUpgradeCost()
	if coins < cost:
		return false
	coins -= cost
	upgradeHealth += 1
	upgradesChanged.emit()
	return true

# ---- SHOP UPGRADES/ LOGIC ABOVE ----


# ---- ENEMY DEATH LOGIC ----
const DROP_CHANCE = {
	"bat": 0.25,
	"skeleton": 0.5,
	"levelBoss": 1
}

func _onEnemyDeath(value: int, enemyName: String):
	print(enemyName, " has died.")
	var chance = DROP_CHANCE.get(enemyName, 0.0)
	if randf() < chance:
		coins += value

# ---- PLAYER DEATH LOGIC ----

signal playerDied

func _onPlayerDeath():
	print("signal made it to gamestate")
	playerDied.emit()
