extends Area2D
@onready var shiny_beacon: AudioStreamPlayer2D = $"Shiny Beacon"
@onready var shiny_pickup: AudioStreamPlayer2D = $"Shiny Pickup"

func _ready() -> void:
	shiny_beacon.play()

func _on_body_entered(body: Node2D) -> void:
	print("My Memories are coming back to me")
	queue_free()
