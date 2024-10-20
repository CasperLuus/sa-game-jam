extends Area2D

@onready var sleep_prompt: RichTextLabel = $"Sleep Prompt"
@onready var player: CharacterBody2D = $"../../Node2D/Player"

var SLEEP_ENABLED_BOOL = false

func _on_body_entered(body: Node2D) -> void:
	sleep_prompt.visible = true
	SLEEP_ENABLED_BOOL = true
	if Input.is_action_just_pressed("sleep"):
		pass

func _on_body_exited(body: Node2D) -> void:
	sleep_prompt.visible = false
	SLEEP_ENABLED_BOOL = false
