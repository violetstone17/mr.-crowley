extends CharacterBody2D

#set as a const so it can be modified here and only here.
#any modulation of player speed can come from an external multiplyer somewhere else
@export var speed = 300.0
const JUMP_VELOCITY = -400.0
var screen_size #size of game window

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("moveLeft", "moveRight")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	direction = Input.get_axis("moveUp", "moveDown")
	if direction:
		velocity.y = direction * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed # normalize set's length back to 1 (unit length)
		#$AnimatedSprite2D.play()
	else:
		#$AnimatedSprite2D.stop()
		pass #delete this when you bring back sprite animation
	
	#no longer need to clamp player to viewport (since it's going to change alwyas) will keep here in case
	#position = position.clamp(Vector2.ZERO, (screen_size - Vector2(40, 40))) #the -20 will need to be adjusted later to account for different sprite size

	move_and_slide()
