extends Area2D

@onready var light: CharacterBody2D = $"../Player And Light/FollowingLight"
@onready var player: CharacterBody2D = $"../Player And Light/Player"

var SHRINK_RATE: float = 0.8;
var GROW_RATE: float = 0.4
var IS_IN_CAMP = false

func _process(delta: float) -> void:
	if light and player:
		print("process")
		print(light)
		print(player)
		var light_point_light = light.get_child(0)
		
		if IS_IN_CAMP:
			if light.scale.x > player.FOLLOWING_LIGHT_MIN_SIZE:
				light.scale -= Vector2(SHRINK_RATE, SHRINK_RATE) * delta
			else:
				light_point_light.visible = false
		else:
			if light.scale.x < player.FOLLOWING_LIGHT_MAX_SIZE and light_point_light.visible and not player.FOLLOWING_LIGHT_SHRINK_BOOL:
				light.scale += Vector2(GROW_RATE, GROW_RATE) * delta
			else: 
				player.FOLLOWING_LIGHT_SHRINK_BOOL = light_point_light.visible
			

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("hello")
		IS_IN_CAMP = true
		body.FOLLOWING_LIGHT_SHRINK_BOOL = false

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		print("goodbye")
		var light_point_light = light.get_child(0)
		
		IS_IN_CAMP = false
		light.scale = Vector2(player.FOLLOWING_LIGHT_MIN_SIZE, player.FOLLOWING_LIGHT_MIN_SIZE)
		light_point_light.visible = true
