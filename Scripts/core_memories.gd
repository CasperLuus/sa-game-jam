extends Area2D
@onready var shiny_beacon: AudioStreamPlayer2D = $"Shiny Beacon"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	print("My Memories are coming back to me")
	shiny_beacon.stop()
	GameManager.memory_core_count += 1
	animation_player.play("pickup")
