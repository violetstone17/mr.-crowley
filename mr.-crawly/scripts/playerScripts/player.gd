extends CharacterBody2D

# --- EXPORTS:
@export var speed = 300.0
@export var baseAttackDamage: int = 10
@export var attackCooldownTime: float = 0.5 #seconds between swings
@export var health: int = 100
@export var iframeDuration: float = 0.5

# --- STATE
var attackCooldown: float = 0.0 	#counts down to 0; 0 means 'can attack'
var iframes: float

# --- NODE REFERENCES
# the hitbox Area2D that sits infront of the player
@onready var hitbox: Area2D = $hitbox
@onready var hurtbox: Area2D = $hurtbox
	# The hitbox's shape. We disable/enable the SHAPE, never the Area (Lessons Log #5:
	# the on/off switch lives on the shape).
@onready var attackShape: CollisionShape2D = $hitbox/CollisionShape2D

var jumpVelocity = -450.0

func _ready() -> void:
	GameState.playerRef = self
	health += GameState.upgradeHealth * GameState.HEALTH_PER_LEVEL
	GameState.maxHealth = health
	GameState.currentHealth = health
	
	add_to_group("player")
	
	#Start with hitbox OFF (no free hits while walking around (right now))
	#set_deferred bedcause we're in a physics-adjacent context
	attackShape.set_deferred("disabled", true)
	
	hurtbox.area_entered.connect(_onHurtboxAreaEntered)
	
	print("upgradeHealth: ", GameState.upgradeHealth, "  health: ", health)
	GameState.upgradesChanged.connect(onUpgradesChanged)

func _physics_process(delta: float) -> void:
	
	# ---------- ATTACK START
	#cooldown ticks down every frame, floored at 0
	attackCooldown = max(0.0, attackCooldown - delta)
	iframes = max(0.0, iframes - delta)
	
	#is_action_just_pressed fires ONCE per pressed 
	# (instead of is_action_pressed which fires every frame held)
	#the former is desired for a swing 
	if Input.is_action_just_pressed("mainAttack") and attackCooldown == 0.0:
		_mainAttack()
	
	# ---------- INPUT // MOVEMENT START
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpVelocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("moveLeft", "moveRight")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	#direction = Input.get_axis("moveUp", "moveDown")
	#if direction:
		#velocity.y = direction * speed
	#else:
		#velocity.y = move_toward(velocity.y, 0, speed)
	
	if velocity.length() > 0:
		#velocity = velocity.normalized() * speed # normalize set's length back to 1 (unit length)
		#$AnimatedSprite2D.play()
		pass
	else:
		#$AnimatedSprite2D.stop()
		pass #delete this when you bring back sprite animation
	
	#no longer need to clamp player to viewport (since it's going to change alwyas) will keep here in case
	#position = position.clamp(Vector2.ZERO, (screen_size - Vector2(40, 40))) #the -20 will need to be adjusted later to account for different sprite size

	move_and_slide()
		# ---------- INPUT // MOVEMENT END

func _mainAttack() -> void:
	# 1. Start cooldown immediately, so this frame's press can't retrigger
	attackCooldown = attackCooldownTime
	
	hitbox.damage = baseAttackDamage #add weapon augmentation here
	# 2. Turn hitbox on. any enemy hurtbox overlapping it this instant will fire its own area_entered signal (and the enemy handles the rest)
	# purpose of this method: this script never touches enemy health
	attackShape.set_deferred("disabled", false)
	# 3. Schedule the hitbox to turn off
	#    A Timer node would also work; a pending call is one less node to wire.
	#    0.15s is a short "active frames" window, like a real swing arc.
	#    If you want faster feedback on hit timing, tune this number in the Inspector
	#    by exporting it like the others.
	await get_tree().create_timer(0.15).timeout
	attackShape.set_deferred("disabled", true)

func _onHurtboxAreaEntered(area: Area2D) -> void:
	#print("PLAYER hurtbox sees: ", area.name)
	# <- does this signal fire?
	if "damage" in area:
		print("player is damaged: ", area.damage)
		takeDamage(area.damage)

func onUpgradesChanged() -> void:
	health += GameState.HEALTH_PER_LEVEL
	GameState.maxHealth = health
	GameState.currentHealth = health

func takeDamage(amount: int) -> void:
	if iframes > 0.0:
		return
	iframes = iframeDuration
	health -= amount
	GameState.currentHealth = health
	print(name, " took ", amount, " damage. Health: ", health)
	if health <= 0:
		die()

func die() -> void:
	print(name, " has died!")
	queue_free()
