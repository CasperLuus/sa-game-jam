extends CharacterBody2D

@export var IS_SHRINKING = false
@export var SHOULD_USE_MULTIPLIER = false
@export var FLICKER_AMPLITUDE = 0.7
@export var FLICKER_SPEED = 2.0

@onready var _1_strings: AudioStreamPlayer2D = $"1-Strings"
@onready var _2_bass: AudioStreamPlayer2D = $"2-Bass"
@onready var _3_kicks: AudioStreamPlayer2D = $"3-Kicks"
@onready var _4_percs: AudioStreamPlayer2D = $"4-Percs"

var REACHED_MIN_SIZE: bool = false

const MIN_SIZE = 0.05
const MAX_SIZE = 1
const SHRINK_MULTIPLIER = 2
const SHRINK_RATE = 0.004
const MEMORY_CORE_ADD_RATE = 0.001

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
	_music_smt()
		
func _shrink_following_light(delta):
	# Gradually decrease the scale over time
	if scale.x > 0.05:
		var shrink_rate = SHRINK_RATE - GameManager.memory_core_count * MEMORY_CORE_ADD_RATE
		print(shrink_rate)
		var shrink_size = shrink_rate * SHRINK_MULTIPLIER
		scale -= Vector2(shrink_size, shrink_size) * delta
	elif scale.x <= 0.05:
		REACHED_MIN_SIZE = true

func _music_smt():
	if scale.x < 0.2 and !_4_percs.playing:
		_4_percs.play()
	elif scale.x < 0.3 and !_3_kicks.playing:
		_3_kicks.play()
	elif scale.x < 0.4 and !_2_bass.playing:
		_2_bass.play()
	elif scale.x < 0.5 and !_1_strings.playing:
		_1_strings.play()
