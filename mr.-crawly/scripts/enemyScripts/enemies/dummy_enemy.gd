extends CharacterBody2D

# --- SIGNALS
signal enemyDead

# --- EXPORTS
@export var max_health: float = 30

# --- STATE
var health: float


# --- NODE REFERENCES
# The hurtbox: an Area2D covering the enemy's body. It doesn't attack anything —
# it exists to be overlapped BY hitboxes and to report that fact.
@onready var hurtbox: Area2D = $hurtbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# put enemy in group so it can be correctly identified.
	add_to_group("enemy")
	health = max_health
	hurtbox.area_entered.connect(_onHurtboxAreaEntered)

func _process(delta: float) -> void:
	pass

func _onHurtboxAreaEntered(area: Area2D) -> void:
	if "damage" in area:
		takeDamage(area.damage)

func takeDamage(amount: int) -> void:
	health -= amount
	print(name, " took ", amount, " damage. Health: ", health)
	if health <= 0:
		die()

func die() -> void:
	print(name, "has died!")
	enemyDead.emit()
	queue_free()
