extends CharacterBody2D

@onready var light_aura: PointLight2D = $"Light Aura"

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -850.0

@export var FOLLOWING_LIGHT: CharacterBody2D
@export var FOLLOWING_LIGHT_SPEED = 410
@export var FOLLOWING_LIGHT_POS_OFFSET: Vector2
@export var FOLLOWING_LIGHT_SHRINK_BOOL = false
@export var FOLLOWING_LIGHT_SHRINK_MULTIPLIER = 1
const FOLLOWING_LIGHT_SHRINK_RATE = 0.01

func _ready() -> void:
	FOLLOWING_LIGHT.position = position + FOLLOWING_LIGHT_POS_OFFSET
	
func _process(delta: float) -> void:
	_physics_process(delta)
	_move_following_light()
	if FOLLOWING_LIGHT_SHRINK_BOOL:
		_shrink_following_light(delta)

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
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#print("Jumped")
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		#print("Moving")
		velocity.x = direction * SPEED
	else:
		#print("Decelerating")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	$AnimatedSprite2D.play()
	move_and_slide()

func _move_following_light() -> void:
	FOLLOWING_LIGHT.velocity = FOLLOWING_LIGHT.position.direction_to(position + 
		FOLLOWING_LIGHT_POS_OFFSET) * FOLLOWING_LIGHT_SPEED 
	FOLLOWING_LIGHT.move_and_slide()

func _on_hazard_detection_area_entered(area: Area2D) -> void:
	print(area.name)
	if area.name == "Spike Hazard":
		_handle_player_death()
	elif area.name == "Water Hazard":
		print("less death")
		FOLLOWING_LIGHT_SHRINK_MULTIPLIER = 1.1

func _on_hazard_detection_area_exited(area: Area2D) -> void:
	if area.name == "Water Hazard":
		print("less death")
		FOLLOWING_LIGHT_SHRINK_MULTIPLIER = 1

func _shrink_following_light(delta):
	# Gradually decrease the scale over time
	if FOLLOWING_LIGHT.scale.x > 0.05:
		var shrink_size = FOLLOWING_LIGHT_SHRINK_RATE * FOLLOWING_LIGHT_SHRINK_MULTIPLIER
		FOLLOWING_LIGHT.scale -= Vector2(shrink_size, shrink_size) * delta
	elif FOLLOWING_LIGHT.scale.x <= 0.05:
		_handle_player_death()

func _handle_player_death():
	#set speed to 0
	SPEED = 0
	#make light min size
	FOLLOWING_LIGHT.scale = Vector2(0.05, 0.05)
	#wait a moment
	var tree = get_tree()
	await tree.create_timer(2).timeout
	#play shatter sound
	#screen goes black
	#ideally both at the same time
	FOLLOWING_LIGHT.get_child(0).enabled = false
	light_aura.enabled = false
	#wait a moment
	await tree.create_timer(2).timeout
	#reset scene
	tree.reload_current_scene()
