extends Area2D

var shrink_rate = 0.1

func _process(delta):
	# Gradually decrease the scale over time
	scale -= Vector2(shrink_rate, shrink_rate) * delta
