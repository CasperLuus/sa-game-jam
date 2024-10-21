extends Node2D

const SPEED = 300

var direction = 1

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var can_eat = false;


func _ready() -> void:
	var num = GameManager.random.randi_range(1,100)
	if num % 2 == 0:
		$AnimatedSprite2D2.free()
	else: 
		$AnimatedSprite2D.free()

func _process(delta):
	if !$RayCastCliffLeft.is_colliding():
		scale.x = -scale.x
		
	if ray_cast_left.is_colliding():
		scale.x = -scale.x

	if (scale.x < 0):
		direction = -1
	else:
		direction = 1

	position.x += direction * SPEED * delta
	
	if can_eat and Input.is_action_just_pressed("sleep") and GameManager.food_count < 3:
		GameManager.food_count += 1
		free()

func _on_pickup_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		can_eat = true


func _on_pickup_body_exited(body: Node2D) -> void:
	if (body.name == "Player"):
		can_eat = false
