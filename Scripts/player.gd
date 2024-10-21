extends CharacterBody2D

@onready var light_aura: PointLight2D = $"Light Aura"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
# sounds
@onready var glass_breaking: AudioStreamPlayer2D = $"Audio/Glass Breaking"
@onready var walkies: AudioStreamPlayer2D = $Audio/Walkies
@onready var _1_strings: AudioStreamPlayer2D = $"Audio/1-Strings"
@onready var _2_bass: AudioStreamPlayer2D = $"Audio/2-Bass"
@onready var _3_kicks: AudioStreamPlayer2D = $"Audio/3-Kicks"
@onready var _4_percs: AudioStreamPlayer2D = $"Audio/4-Percs"
@onready var whispers: AudioStreamPlayer2D = $Audio/Whispers
@onready var water_walkies: AudioStreamPlayer2D = $"Audio/Water Walkies"
@onready var water_entry: AudioStreamPlayer2D = $"Audio/Water Entry"
@onready var landing: AudioStreamPlayer2D = $Audio/Landing
@onready var jump: AudioStreamPlayer2D = $Audio/Jump
@onready var cave_ambience: AudioStreamPlayer2D = $"Audio/Cave Ambience"

@export var LIGHT_SPEED = 410
@export var LIGHT_ACCELERATION = 100
@export var LIGHT_POS_OFFSET: Vector2

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -850.0
@export var JUMP_HEIGHT = 850.0

var IS_SLEEPING: bool = false
var HAS_STARTED_DAY: bool = false
var HAS_DAY_ENDED: bool = false

var HAS_JUMPED: bool = false

@export var FOLLOWING_LIGHT: CharacterBody2D

@export var NORMAL_GRAVITY_MULTIPLIER: float = 0.5
@export var GLIDE_GRAVITY_MULTIPLIER: float = 0.2
var _current_multiplier = NORMAL_GRAVITY_MULTIPLIER

func _ready() -> void:
	FOLLOWING_LIGHT.visible = false
	_play_sleeping_animation()
	FOLLOWING_LIGHT.position = position + LIGHT_POS_OFFSET
	
func _process(delta: float) -> void:
	if not HAS_DAY_ENDED and not HAS_STARTED_DAY:
		_play_sleeping_animation()
		if Input.is_action_just_pressed("move_up"):
			SPEED = 300
			HAS_STARTED_DAY = true
	elif not HAS_DAY_ENDED:
		_physics_process(delta)
		_move_following_light(delta)
		if FOLLOWING_LIGHT.REACHED_MIN_SIZE:
			_handle_player_death()
		if IS_SLEEPING:
			_handle_player_sleeping()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		walkies.stop()
		water_walkies.stop()
		#print("Airtime")
		if velocity.y < 0: 
			velocity += get_gravity() * delta * NORMAL_GRAVITY_MULTIPLIER
		else:
			velocity += get_gravity() * delta * _current_multiplier
			
		$AnimatedSprite2D.animation = "Floating"
	else:
		if HAS_JUMPED:
			print("landed")
			jump.stop()
			walkies.stop()
			water_walkies.stop()
			landing.play()
			HAS_JUMPED = false
		if velocity.is_zero_approx():
			print("Idle")
			walkies.stop()
			water_walkies.stop()
			$AnimatedSprite2D.animation = "Idle"
		else:
			print("Bouncing")
			if !walkies.playing and !FOLLOWING_LIGHT.SHOULD_USE_MULTIPLIER:
				walkies.play()
			elif water_walkies.playing and FOLLOWING_LIGHT.SHOULD_USE_MULTIPLIER:
				water_walkies.play()
			$AnimatedSprite2D.animation = "Jump"
	
	# Handle jump.
	if Input.is_action_just_pressed("move_up"):
		if is_on_floor():
			jump.play()
			HAS_JUMPED = true
			velocity.y = JUMP_VELOCITY
		_current_multiplier = GLIDE_GRAVITY_MULTIPLIER
	
	if Input.is_action_just_released("move_up"):
		_current_multiplier = NORMAL_GRAVITY_MULTIPLIER
	 
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		#print("Moving")
		velocity.x = direction * SPEED 
	else:
		#print("Decelerating")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# change sprite direction
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	$AnimatedSprite2D.play()
	move_and_slide()

func _move_following_light(delta: float) -> void:
	var direction = FOLLOWING_LIGHT.position.direction_to(position + LIGHT_POS_OFFSET)
	var distance = position.distance_to(FOLLOWING_LIGHT.position + LIGHT_POS_OFFSET)
	FOLLOWING_LIGHT.velocity += direction * LIGHT_ACCELERATION * delta * distance
	
	var clamp = LIGHT_SPEED 
	if (direction.x > 0):
		FOLLOWING_LIGHT.velocity.x = min(FOLLOWING_LIGHT.velocity.x, clamp)
	else: 
		FOLLOWING_LIGHT.velocity.x = max(FOLLOWING_LIGHT.velocity.x, -clamp)
		
	if (direction.y > 0):
		FOLLOWING_LIGHT.velocity.y = min(FOLLOWING_LIGHT.velocity.y, clamp)
	else: 
		FOLLOWING_LIGHT.velocity.y = max(FOLLOWING_LIGHT.velocity.y, -clamp)
	
	if distance > 2000:
		FOLLOWING_LIGHT.position += (distance - 2000) * direction
	
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
	HAS_DAY_ENDED = true
	_play_sleeping_animation()
	GameManager._move_to_next_day()

func _handle_player_death():
	HAS_DAY_ENDED = true
	#set speed to 0
	SPEED = 0
	JUMP_VELOCITY = 0
	#make light min size
	FOLLOWING_LIGHT.scale = Vector2(FOLLOWING_LIGHT.MIN_SIZE, FOLLOWING_LIGHT.MIN_SIZE)
	#wait a moment
	var tree = get_tree()
	await tree.create_timer(2).timeout
	#play shatter sound
	glass_breaking.play()
	#screen goes black
	#ideally both at the same time
	FOLLOWING_LIGHT.get_child(0).visible = false
	light_aura.scale = Vector2(0.5, 0.5)
	#wait a moment
	await tree.create_timer(2).timeout
	#hide the character
	GameManager._restart_day()
