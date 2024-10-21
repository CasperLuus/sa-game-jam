extends Area2D

@onready var player: CharacterBody2D = $"../../Player And Light/Player"
@onready var camp: Area2D = $".."
@onready var sleep_text: RichTextLabel = $"Sleep Prompt"

var is_sleep_enabled = false

func _ready() -> void:
	sleep_text.visible = false

func _process(delta: float) -> void:
	if camp.HAS_LEFT_CAMP and is_sleep_enabled:
		if Input.is_action_just_pressed("sleep"):
			player.IS_SLEEPING = true

func _on_body_entered(body: Node2D) -> void:
	if camp.HAS_LEFT_CAMP:
		sleep_text.visible = true
		is_sleep_enabled = true

func _on_body_exited(body: Node2D) -> void:
	sleep_text.visible = false
	is_sleep_enabled = false
