extends Node2D

@onready var sleep_prompt: RichTextLabel = $"Nest/Sleep Prompt"
@onready var player_and_light: CharacterBody2D = $"Player And Light"

var GROW_RATE: float = 0.8;
var IS_IN_CAMP = false
var SLEEP_ENABLED_BOOL = false

var player
var light
var light_point_light: PointLight2D

func _on_ready() -> void:
	_get_player_and_light()

func _process(delta: float) -> void:
	if light and player:
		if IS_IN_CAMP:
			if light.scale.x > player.FOLLOWING_LIGHT_MIN_SIZE:
				light.scale -= Vector2(GROW_RATE, GROW_RATE) * delta
			else:
				light_point_light.visible = false
		else:
			if light.scale.x < player.FOLLOWING_LIGHT_MAX_SIZE and light_point_light.visible and not player.FOLLOWING_LIGHT_SHRINK_BOOL:
				light.scale += Vector2(GROW_RATE, GROW_RATE) * delta
			else: 
				player.FOLLOWING_LIGHT_SHRINK_BOOL = light_point_light.visible
			
func _get_player_and_light():
	player = player_and_light.get_child(0)
	light = player_and_light.get_child(1)
	light_point_light = light.get_child(0)

func _on_camp_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if not light or not player:
			_get_player_and_light()
		
		IS_IN_CAMP = true
		player.FOLLOWING_LIGHT_SHRINK_BOOL = false

func _on_camp_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		if not light or not player:
			_get_player_and_light()
		
		IS_IN_CAMP = false
		light.scale = Vector2(player.FOLLOWING_LIGHT_MIN_SIZE, player.FOLLOWING_LIGHT_MIN_SIZE)
		light_point_light.visible = true

func _on_nest_body_entered(body: Node2D) -> void:
	sleep_prompt.visible = true
	SLEEP_ENABLED_BOOL = true

func _on_nest_body_exited(body: Node2D) -> void:
	sleep_prompt.visible = false
	SLEEP_ENABLED_BOOL = false
