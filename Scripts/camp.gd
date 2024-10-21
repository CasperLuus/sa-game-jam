extends Area2D

@onready var light: CharacterBody2D = $"../Player And Light/FollowingLight"
@onready var player: CharacterBody2D = $"../Player And Light/Player"

var SHRINK_RATE: float = 0.8;
var GROW_RATE: float = 0.4
var IS_IN_CAMP = false
var HAS_LEFT_CAMP = false

var SHRINK_SIZE

func _process(delta: float) -> void:
	if light and player:
		if IS_IN_CAMP:
			if light.scale.x > light.MIN_SIZE:
				light.scale -= Vector2(SHRINK_RATE, SHRINK_RATE) * delta
			else:
				light.visible = false
		else:
			if !SHRINK_SIZE:
				SHRINK_SIZE = light.MAX_SIZE
			if light.scale.x <= SHRINK_SIZE and light.visible and not light.IS_SHRINKING:
				light.scale += Vector2(GROW_RATE, GROW_RATE) * delta
			else: 
				light.IS_SHRINKING = light.visible
			

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		IS_IN_CAMP = true
		light.IS_SHRINKING = false
		SHRINK_SIZE = light.scale.x

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		HAS_LEFT_CAMP = true
		IS_IN_CAMP = false
		light.scale = Vector2(light.MIN_SIZE, light.MIN_SIZE)
		light.visible = true
