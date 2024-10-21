extends Area2D
class_name InteractionArea

@export var action_name: String = "interact"

var interact: Callable = func():
	pass



func _on_body_entered(body):
	Interaction
	



func _on_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
