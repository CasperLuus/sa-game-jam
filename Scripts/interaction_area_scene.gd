extends Area2D
class_name InteractionArea

@export var action_name: String = "interact"

var interact: Callable = func():
	pass



func _on_body_entered(body):
	interactionmanager.register_area(self)

func _on_body_exited(body: Node2D) -> void:
	InteractionArea.unregister_area(self)
