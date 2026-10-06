class_name EnemyBase
extends CharacterBody2D

# ---- THIS SCRIPT SETS UP BASIC VARIABLES AND DAMAGE AND DEATH FUNCTIONS ----

#exported variables can be tweaked per enemy in inspector
@export var maxHealth: int = 30
@export var speed: float = 100.0
@export var enemyStrength: int = 10

# -- HITBOX IS TO HIT ENEMY ||| HURTBOX IS DAMAGE RECIEVED FROM ENEMY --
@export var hitbox: Area2D
@export var hurtbox: Area2D
@export var detectionRange: Area2D

@export var player: Node2D = null

#track current health
var currentHealth: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentHealth = maxHealth
	detectionRange.body_entered.connect(_onPlayerSpotted)
	detectionRange.body_exited.connect(_onPlayerLost)

#universal take damage function
func takeDamage(amount: int) -> void:
	currentHealth -= amount
	print(name, "took", amount, " damage. Health: ", currentHealth)
	if currentHealth <= 0:
		die()
	
func die() -> void:
	print(name, "has died!")
	queue_free()

func _onPlayerSpotted(b: Node2D) -> void:
	if b.is_in_group("player"):
		player = b #remember who we saw

func _onPlayerLost(b: Node2D) -> void:
	if b == player:
		player = null #player left range, forget them
