extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var total_time = 0

@onready var stars: Array[Sprite2D] = [$Stars/Star1, $Stars/Star2, $Stars/Star3, $Stars/Star4]
@onready var food: Array[Sprite2D] = [$FoodBar/BugEmpty/BugFull, $FoodBar/BugEmpty2/BugFull, $FoodBar/BugEmpty3/BugFull]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var threshold = GameManager.memory_core_count + GameManager.temp_memory_core_count
	
	total_time += delta
	var alpha_for_temp = cos(total_time) 
	for i in range(stars.size()):
		stars[i].visible = threshold > i
		if (GameManager.memory_core_count <= i):
			stars[i].modulate.a = alpha_for_temp
	
	for i in range(food.size()):
		food[i].visible = GameManager.food_count > i

		
