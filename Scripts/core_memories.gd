extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print("My Memories are coming back to me")
	queue_free()
