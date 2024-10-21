extends CharacterBody2D


@export var IS_SHRINKING = false
@export var SHOULD_USE_MULTIPLIER = false

var REACHED_MIN_SIZE: bool = false

const MIN_SIZE = 0.05
const MAX_SIZE = 0.8
const SHRINK_MULTIPLIER = 1.5
const SHRINK_RATE = 0.001

func _process(delta: float) -> void:
	if IS_SHRINKING:
		_shrink_following_light(delta)

func _shrink_following_light(delta):
	# Gradually decrease the scale over time
	if scale.x > 0.05:
		var shrink_size = SHRINK_RATE * SHRINK_MULTIPLIER
		scale -= Vector2(shrink_size, shrink_size) * delta
	elif scale.x <= 0.05:
		REACHED_MIN_SIZE = true
