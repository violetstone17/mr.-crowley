extends Node

signal coinsChanged(newAmount)



#for player tracking/ position data
var playerRef: Node2D = null

#Run state
var coins: int = 0:
	set(value):
		coins = value
		coinsChanged.emit(coins)

var hasDungeonKey: bool = false
var dungeonCleared: bool = false


#upgrade levels (cantina purchases)
var upgradeHealth: int = 0
