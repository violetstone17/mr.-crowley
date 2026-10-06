extends Node


#for player tracking/ position data
var playerRef: Node2D = null

#Run state
var coins: int = 0
var hasDungeonKey: bool = true
var dungeonCleared: bool = false


#upgrade levels (cantina purchases)
var upgradeHealth: int = 0
