extends Area2D

@export var bugs: Array[CharacterBody2D]

@export var spawn_chance: int = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get a random number (1-x) -> if the number is smaller than spawn chance dont spawn
	# all bugs enabled = false
	
	for bug in bugs:
		bug.visible = false
	var rng = GameManager.random.randf_range(1, 100)
	print (rng)
	if rng < spawn_chance:
		bugs.pick_random().visible = true
		print ("bug spawn")
	# Pick a random bug to spawn (only one of the two) 
	# one bug.enabled = true
