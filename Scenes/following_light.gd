extends CharacterBody2D


@export var SPEED = 350
@export var PLAYER: CharacterBody2D
@export var OFFSET: Vector2

func _ready() -> void:
	position = PLAYER.position + OFFSET


func _process(delta: float) -> void:
	velocity = position.direction_to(PLAYER.position + OFFSET) * SPEED 

	move_and_slide()
