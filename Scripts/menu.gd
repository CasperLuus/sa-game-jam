extends Control

var state = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if state == true:
		$Buttons/Continue.grab_focus()
	else:
		$Buttons/Continue.disabled
		$"Buttons/New Game".grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_continue_pressed() -> void:
	# this would be to whatever state they were last saved at, but will always take them to the cave
	get_tree().change_scene_to_file("res://Scenes/node_2d.tscn")

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/node_2d.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
