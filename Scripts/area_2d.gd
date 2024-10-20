extends Area2D

@export var PLAYER_AND_LIGHT: CharacterBody2D
@export var GROW_RATE: float = 0.8;
var PLAYER
var LIGHT
var PLAYER_POINT_LIGHT: PointLight2D
var LIGHT_POINT_LIGHT: PointLight2D


func _on_ready() -> void:
	PLAYER = PLAYER_AND_LIGHT.get_child(0)
	LIGHT = PLAYER_AND_LIGHT.get_child(1)
	
	PLAYER_POINT_LIGHT = PLAYER.get_child(3) 
	LIGHT_POINT_LIGHT = LIGHT.get_child(0)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		#PLAYER_POINT_LIGHT.visible = false
		LIGHT_POINT_LIGHT.visible = false
		PLAYER.FOLLOWING_LIGHT_SHRINK_BOOL = false
		

func _process(delta: float) -> void:
	if LIGHT.scale.x < 0.8 and LIGHT_POINT_LIGHT.visible and not PLAYER.FOLLOWING_LIGHT_SHRINK_BOOL:
		LIGHT.scale += Vector2(1, 1) * GROW_RATE * delta
	else: 
		PLAYER.FOLLOWING_LIGHT_SHRINK_BOOL = LIGHT_POINT_LIGHT.visible

func _on_body_exited(body: Node2D) -> void:
	# I was trying to make the light start smaller when leaving the cave home, but its not working for some reason.
	# im going to bed now, this is laters problem
	print(body.name)
	if body.name == "Player":
		LIGHT.scale = Vector2(0.05, 0.05)
		print(body.FOLLOWING_LIGHT)
		
		#PLAYER_POINT_LIGHT.visible = true
		LIGHT_POINT_LIGHT.visible = true
			
		
