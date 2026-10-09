class_name EnemyBase
extends CharacterBody2D

# ---- THIS SCRIPT SETS UP BASIC VARIABLES AND DAMAGE AND DEATH FUNCTIONS ----

#exported variables can be tweaked per enemy in inspector
@export var maxHealth: int = 30
@export var speed: float = 100.0
@export var enemyStrength: int = 10
@export var attackCooldownTime: float = 0.5


# -- HITBOX IS TO HIT ENEMY ||| HURTBOX IS DAMAGE RECIEVED FROM ENEMY --
@onready var hitbox: Area2D = $hitbox
@onready var hurtbox: Area2D = $hurtbox
@onready var detectionRange: Area2D = $detectionBox
@onready var attackShape: CollisionShape2D = $hitbox/CollisionShape2D
@onready var attackRange: Area2D = $attackRange


#track current health
var currentHealth: int
var attackCooldown: float
var player: Node2D = null
var playerInRange: bool = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemy")
	
	currentHealth = maxHealth
	detectionRange.body_entered.connect(_onPlayerSpotted)
	detectionRange.body_exited.connect(_onPlayerLost)
	hurtbox.area_entered.connect(_onHurtboxAreaEntered)
	attackRange.body_entered.connect(_onAttackRangeEntered)
	attackRange.body_exited.connect(_onAttackRangeExited)
	
	attackShape.set_deferred("disabled", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	attackCooldown = max(0.0, attackCooldown - delta)
	if player:
		#print("chasing player")
		chase()
		#print(playerInRange)
		if playerInRange and attackCooldown == 0.0:
			#print("in attack range")
			attack()
	else:
		pass

func _onAttackRangeEntered(b: Node2D) -> void:
	#print(b, " has entered range")
	if b.is_in_group("player"):
		playerInRange = true

func _onAttackRangeExited(b: Node2D) -> void:
	if b.is_in_group("player"):
		playerInRange = false

func _onHurtboxAreaEntered(area: Node2D) -> void:
	if "damage" in area:
		takeDamage(area.damage)

func _onPlayerSpotted(b: Node2D) -> void:
	if b.is_in_group("player"):
		player = b #remember who we saw

func _onPlayerLost(b: Node2D) -> void:
	if b == player:
		player = null #player left range, forget them

func attack() -> void:
	## 1. Start cooldown immediately, so this frame's press can't retrigger
	#attackCooldown = attackCooldownTime
	#hitbox.damage = enemyStrength
	## 2. Turn hitbox on. when player hurtbox overlapping it this instant will fire its own area_entered signal (and the player handles the rest)
	## purpose of this method: this script never touches enemy health
	#attackShape.set_deferred("disabled", false)
	## 3. Schedule the hitbox to turn off
	##    A Timer node would also work; a pending call is one less node to wire.
	##    0.15s is a short "active frames" window, like a real swing arc.
	##    If you want faster feedback on hit timing, tune this number in the Inspector
	##    by exporting it like the others.
	#await get_tree().create_timer(0.15).timeout
	#attackShape.set_deferred("disabled", true)
	
	attackCooldown = attackCooldownTime
	hitbox.damage = enemyStrength
	#dprint("BAT SWING: shape enabled, damage = ", hitbox.damage)
	attackShape.set_deferred("disabled", false)
	await get_tree().physics_frame
	await get_tree().physics_frame
	#for a in hitbox.get_overlapping_areas():
		#print("overlapping: ", a.get_parent().name, "/", a.name)
	#print("shape disabled: ", attackShape.disabled,
	#" | monitorable: ", hitbox.monitorable,
	#" | overlapping: ", hitbox.get_overlapping_areas())
	await get_tree().create_timer(0.15).timeout
	attackShape.set_deferred("disabled", true)

# finds direct vector to player and moves accordingy
func chase():
	var target: Vector2 = player.global_position
	
	target += Vector2(randf_range(-20,20), randf_range(-20,20))
	velocity = (target - global_position).normalized() * speed
	move_and_slide()

#universal take damage function
func takeDamage(amount: int) -> void:
	currentHealth -= amount
	print(name, " took ", amount, " damage. Health: ", currentHealth)
	if currentHealth <= 0:
		die()

func die() -> void:
	print(name, " has died!")
	queue_free()
