extends Node2D

func findByClass(node: Node, className : String, result : Array) -> void:
	if node.is_class(className) :
		result.push_back(node)
	for child in node.get_children():
		findByClass(child, className, result)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var res: Array[CollisionPolygon2D] = []
	findByClass(self, "CollisionPolygon2D", res)
	for node in res:
		var newNode = LightOccluder2D.new()
		newNode.occluder = OccluderPolygon2D.new()
		newNode.occluder.polygon = node.polygon;
		newNode.position = node.position
		newNode.scale = node.scale / 2
		add_child(newNode)
