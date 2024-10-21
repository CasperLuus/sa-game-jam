extends Node2D

const SPEED = 300

var direction = 1

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var can_eat = false;

func _process(delta):
	if ray_cast_right.is_colliding():
			direction = -1
			animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
			direction = 1
			animated_sprite.flip_h = false
	
	if !$RayCastCliffLeft.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if !$RayCastCliffRight.is_colliding():
		direction = 1
		animated_sprite.flip_h = false			

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
