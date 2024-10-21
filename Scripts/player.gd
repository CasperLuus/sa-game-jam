extends CharacterBody2D

@onready var light_aura: PointLight2D = $"Light Aura"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var LIGHT_SPEED = 410
@export var LIGHT_BOUNCE = 50
@export var LIGHT_ACCELERATION = 100
@export var LIGHT_DISTANCE_CUTOFF = 50
@export var LIGHT_POS_OFFSET: Vector2

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -850.0

var IS_SLEEPING: bool = false
var HAS_STARTED_DAY: bool = false

@export var FOLLOWING_LIGHT: CharacterBody2D

func _ready() -> void:
	FOLLOWING_LIGHT.visible = false
	_play_sleeping_animation()
	FOLLOWING_LIGHT.position = position + LIGHT_POS_OFFSET
	
func _process(delta: float) -> void:
	if not HAS_STARTED_DAY:
		_play_sleeping_animation()
		if Input.is_action_just_pressed("move_up"):
			SPEED = 300
			HAS_STARTED_DAY = true
	else:
		_physics_process(delta)
		_move_following_light(delta)
		if IS_SLEEPING:
			_handle_player_sleeping()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		#print("Airtime")
		$AnimatedSprite2D.animation = "Floating"
		velocity += get_gravity() * delta * 0.5
	elif velocity.is_zero_approx():
		#print("Idle")
		$AnimatedSprite2D.animation = "Idle"
	else:
		#print("Bouncing")
		$AnimatedSprite2D.animation = "Jump"
	
	$AnimatedSprite2D.flip_h = velocity.x < 0
	
	# Handle jump.
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		#print("Jumped")
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		#print("Moving")
		velocity.x = direction * SPEED
	else:
		#print("Decelerating")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	$AnimatedSprite2D.play()
	move_and_slide()

func _move_following_light(delta: float) -> void:
	var direction = FOLLOWING_LIGHT.position.direction_to(position + LIGHT_POS_OFFSET)
	var distance = position.distance_to(FOLLOWING_LIGHT.position + LIGHT_POS_OFFSET)
	FOLLOWING_LIGHT.velocity += direction * LIGHT_ACCELERATION * delta * distance
	
	#if velocity.is_zero_approx() and distance < LIGHT_DISTANCE_CUTOFF:
		#FOLLOWING_LIGHT.velocity = Vector2.ZERO
		
	
	var clamp = LIGHT_SPEED 
	if (direction.x > 0):
		FOLLOWING_LIGHT.velocity.x = min(FOLLOWING_LIGHT.velocity.x, clamp)
	else: 
		FOLLOWING_LIGHT.velocity.x = max(FOLLOWING_LIGHT.velocity.x, -clamp)
		
	if (direction.y > 0):
		FOLLOWING_LIGHT.velocity.y = min(FOLLOWING_LIGHT.velocity.y, clamp)
	else: 
		FOLLOWING_LIGHT.velocity.y = max(FOLLOWING_LIGHT.velocity.y, -clamp)
	
	FOLLOWING_LIGHT.move_and_slide()

func _on_hazard_detection_area_entered(area: Area2D) -> void:
	if area.name.contains("Spike Hazard"):
		_handle_player_death()
	elif area.name.contains("Water Hazard"):
		FOLLOWING_LIGHT.SHOULD_USE_MULTIPLIER = true

func _on_hazard_detection_area_exited(area: Area2D) -> void:
	if area.name == "Water Hazard":
		FOLLOWING_LIGHT.SHOULD_USE_MULTIPLIER = false

func _play_sleeping_animation():
	SPEED = 0
	$AnimatedSprite2D.animation = "Sleep"
	$AnimatedSprite2D.play()

func _handle_player_sleeping():
	_play_sleeping_animation()
	GameManager._move_to_next_day()

func _handle_player_death():
	#set speed to 0
	SPEED = 0
	JUMP_VELOCITY = 0
	#make light min size
	FOLLOWING_LIGHT.scale = Vector2(FOLLOWING_LIGHT.MIN_SIZE, FOLLOWING_LIGHT.MIN_SIZE)
	#wait a moment
	var tree = get_tree()
	await tree.create_timer(2).timeout
	#play shatter sound
	#screen goes black
	#ideally both at the same time
	FOLLOWING_LIGHT.get_child(0).visible = false
	light_aura.visible = false
	#wait a moment
	await tree.create_timer(2).timeout
	#hide the character
	animated_sprite.visible = false
	#music goes off
	#wait a moment
	await tree.create_timer(3).timeout
	#reset scene
	tree.reload_current_scene()
