extends Node2D

@onready var sleep_prompt: RichTextLabel = $"Nest/Sleep Prompt"
@onready var player_and_light: CharacterBody2D = $"Player And Light"

@export var GROW_RATE: float = 0.8;

var player
var light
var PLAYER_POINT_LIGHT: PointLight2D
var LIGHT_POINT_LIGHT: PointLight2D

var IS_IN_CAMP = false
var SLEEP_ENABLED_BOOL = false

func _on_ready() -> void:
	player = player_and_light.get_child(0)
	light = player_and_light.get_child(1)
	
	PLAYER_POINT_LIGHT = player.get_child(3) 
	LIGHT_POINT_LIGHT = light.get_child(0)

func _process(delta: float) -> void:
	if light and player:
		if light.scale.x < 0.8 and LIGHT_POINT_LIGHT.visible and not player.FOLLOWING_LIGHT_SHRINK_BOOL:
			light.scale += Vector2(1, 1) * GROW_RATE * delta
		else: 
			player.FOLLOWING_LIGHT_SHRINK_BOOL = LIGHT_POINT_LIGHT.visible

func _on_camp_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		IS_IN_CAMP = true
		if light:
			LIGHT_POINT_LIGHT.visible = false
		if player:
			player.FOLLOWING_LIGHT_SHRINK_BOOL = false

func _on_camp_body_exited(body: Node2D) -> void:
	# I was trying to make the light start smaller when leaving the cave home, but its not working for some reason.
	# im going to bed now, this is laters problem
	print(body.name)
	if body.name == "Player":
		if light:
			light.scale = Vector2(0.05, 0.05)
			LIGHT_POINT_LIGHT.visible = true

func _on_nest_body_entered(body: Node2D) -> void:
	sleep_prompt.visible = true
	SLEEP_ENABLED_BOOL = true

func _on_nest_body_exited(body: Node2D) -> void:
	sleep_prompt.visible = false
	SLEEP_ENABLED_BOOL = false
