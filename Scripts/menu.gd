extends Control

var state = false;
var started = false

var _time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if state == true:
		$Buttons/Continue.grab_focus()
	else:
		$Buttons/Continue.disabled
		$"Buttons/New Game".grab_focus()
		
	$Loading.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Loading.modulate.a = cos(_time*4) + .3
	if started and _time > 3:
		GameManager._switch_scene("res://Scenes/level_1.tscn")
	elif started:
		_time += delta
	
func _on_continue_pressed() -> void:
	# this would be to whatever state they were last saved at, but will always take them to the cave
	$Loading.visible = true
	$Buttons.visible = false
	$Splash.modulate.a = 0.5
	started = true
	

#func _on_new_game_pressed() -> void:
	#get_tree().change_scene_to_file("res://Scenes/node_2d.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
