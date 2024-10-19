extends Area2D

var shrink_rate = 0.01

func _process(delta):
	# Gradually decrease the scale over time
	scale -= Vector2(shrink_rate, shrink_rate) * delta
	# Optional: Stop shrinking when the object gets too small
	if scale.x <= 0.1 or scale.y <= 0.1:
		scale = Vector2(0.1, 0.1)  # Minimum size
