extends Node

var current_scene = null
var random = RandomNumberGenerator.new()

func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() -1)
	print(current_scene)

func _switch_scene(scene_path: String):
	call_deferred("_deferred_switch_scene", scene_path)

func _deferred_switch_scene(scene_path):
	current_scene.free()
	var s = load(scene_path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene

func _move_to_next_day():
	_switch_scene("res://Scenes/black_scene.tscn")
	await get_tree().create_timer(3).timeout
	_switch_scene("res://Scenes/level_1.tscn")
