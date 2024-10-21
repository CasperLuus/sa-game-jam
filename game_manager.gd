extends Node

var current_scene = null
var random = RandomNumberGenerator.new()
var memory_core_count = 0
var temp_memory_core_count = 0
var prev_day_food_count = 3
var food_count = 0

var HAS_EYE_MEMORY: bool = false
var HAS_TEMP_EYE_MEMORY: bool = false
var NAME_EYE_MEMORY = "Eye Memory"
var HAS_HEART_MEMORY: bool = false
var HAS_TEMP_HEART_MEMORY: bool = false
var NAME_HEART_MEMORY = "Heart Memory"
var HAS_STATUE_MEMORY: bool = false
var HAS_TEMP_STATUE_MEMORY: bool = false
var NAME_STATUE_MEMORY = "Statue Memory"
var HAS_TRAPPED_DOOR_MEMORY: bool = false
var HAS_TEMP_TRAPPED_DOOR_MEMORY: bool = false
var NAME_TRAPPED_DOOR_MEMORY = "Trapped Door Memory"

var HAS_KEY: bool = false
var HAS_KEY_TEMP: bool = false

var FLICKED_LEVER: bool = false

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

func _get_is_enabled_memory_core(name: String) -> bool:
	if name == NAME_EYE_MEMORY:
		return !HAS_EYE_MEMORY
	elif name == NAME_HEART_MEMORY:
		return !HAS_HEART_MEMORY
	elif name == NAME_STATUE_MEMORY:
		return !HAS_STATUE_MEMORY
	else:
		return !HAS_TRAPPED_DOOR_MEMORY

func _pickup_memory_core(name: String):
	if name == NAME_EYE_MEMORY:
		HAS_TEMP_EYE_MEMORY = true
	elif name == NAME_HEART_MEMORY:
		HAS_TEMP_HEART_MEMORY = true
	elif name == NAME_STATUE_MEMORY:
		HAS_TEMP_STATUE_MEMORY = true
	elif name == NAME_TRAPPED_DOOR_MEMORY:
		HAS_TEMP_TRAPPED_DOOR_MEMORY = true
	temp_memory_core_count += 1

func _move_to_next_day():
	_switch_scene("res://Scenes/black_scene.tscn")
	await get_tree().create_timer(5).timeout
	# Display something about current day
	_switch_scene("res://Scenes/level_1.tscn")
	memory_core_count += temp_memory_core_count
	HAS_KEY = HAS_KEY_TEMP or HAS_KEY
	temp_memory_core_count = 0
	prev_day_food_count = food_count
	food_count = 0
	if HAS_TEMP_EYE_MEMORY:
		HAS_EYE_MEMORY = true
	if HAS_TEMP_STATUE_MEMORY:
		HAS_STATUE_MEMORY = true
	if HAS_TEMP_HEART_MEMORY: 
		HAS_HEART_MEMORY = true
	if HAS_TEMP_TRAPPED_DOOR_MEMORY:
		HAS_TRAPPED_DOOR_MEMORY = true

func _restart_day():
	_switch_scene("res://Scenes/black_scene.tscn")
	await get_tree().create_timer(5).timeout
	# Display same day
	_switch_scene("res://Scenes/level_1.tscn")
	temp_memory_core_count = 0
	food_count = 0
	HAS_KEY_TEMP = false
	HAS_TEMP_EYE_MEMORY = false
	HAS_TEMP_STATUE_MEMORY = false
	HAS_TEMP_HEART_MEMORY = false
	HAS_TEMP_TRAPPED_DOOR_MEMORY = false
	
