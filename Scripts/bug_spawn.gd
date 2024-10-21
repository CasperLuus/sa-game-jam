extends Area2D

@export var bugs: Array[Node2D]

@export var spawn_chance: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.respawn.connect(_spawn)

func _spawn() -> void:
	# Get a random number (1-x) -> if the number is smaller than spawn chance dont spawn
	# all bugs enabled = false
	
	
	# Pick a random bug to spawn (only one of the two) 
	# one bug.enabled = true
