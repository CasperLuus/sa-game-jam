extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

@onready var lamp: Area2D = $Lamp

func _process(delta: float) -> void:
	_physics_process(delta)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		#print("Airtime")
		$AnimatedSprite2D.animation = "Floating"
		velocity += get_gravity() * delta
	elif velocity.is_zero_approx():
		#print("Idle")
		$AnimatedSprite2D.animation = "Idle"
	else:
		#print("Bouncing")
		$AnimatedSprite2D.animation = "Jump"	
		
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
	
	
# This is going to listen for when the light shrinks (or the darkness creeps) into the players allowed light boundary
# And then do some warning animations, giving them a chance to get out, and then death
func _on_light_area_area_entered(area: Area2D) -> void:
	if area.name == "Light Boundary":
		print("hello")
	else:
		print(area.name, lamp.name)
