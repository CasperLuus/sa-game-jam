extends CharacterBody2D

@export var IS_SHRINKING = false
@export var SHOULD_USE_MULTIPLIER = false
@export var FLICKER_AMPLITUDE = 0.7
@export var FLICKER_SPEED = 2.0

var REACHED_MIN_SIZE: bool = false

const MIN_SIZE = 0.05
const MAX_SIZE = 1
const SHRINK_MULTIPLIER = 2
const SHRINK_RATE = 0.006
const MEMORY_CORE_ADD_RATE = 0.002

@onready var FLICKER_OFFSET = $PointLight2D.energy

var total_time = 0;

func _process(delta: float) -> void:
	if IS_SHRINKING:
		_shrink_following_light(delta)
	if SHOULD_USE_MULTIPLIER:
		total_time += delta
		$PointLight2D.energy = cos(total_time * FLICKER_SPEED) * FLICKER_AMPLITUDE + FLICKER_OFFSET
	else:
		total_time = 90
		$PointLight2D.energy = FLICKER_OFFSET

func _shrink_following_light(delta):
	# Gradually decrease the scale over time
	if scale.x > 0.05:
		var shrink_rate = SHRINK_RATE - GameManager.memory_core_count * MEMORY_CORE_ADD_RATE
		print(shrink_rate)
		var shrink_size
		if SHOULD_USE_MULTIPLIER:
			shrink_size = shrink_rate * SHRINK_MULTIPLIER
		else:
			shrink_size = shrink_rate
		scale -= Vector2(shrink_size, shrink_size) * delta
	elif scale.x <= 0.05:
		REACHED_MIN_SIZE = true
