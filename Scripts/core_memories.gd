extends Area2D

@onready var shiny_beacon: AudioStreamPlayer2D = $"Shiny Beacon"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	var enabled = GameManager._get_is_enabled_memory_core(name)
	print(enabled)
	if(enabled):
		shiny_beacon.play()
	else:
		shiny_beacon.stop()
		$AnimatedSprite2D.visible = false
		$CollisionShape2D.disabled = true

func _on_body_entered(body: Node2D) -> void:
	shiny_beacon.stop()
	GameManager._pickup_memory_core(name)
	animation_player.play("pickup")
