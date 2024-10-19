extends Area2D

@export var shrink_rate = 0.01

func _process(delta):
	# Gradually decrease the scale over time
	if scale.x > 0.05:
		scale -= Vector2(shrink_rate, shrink_rate) * delta
	elif scale.x <= 0.05:
		#play shatter sound
		#screen goes black
		get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")
