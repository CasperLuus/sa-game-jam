extends Node2D

@onready var DOOR_STARS: Array[Sprite2D] = [$Foreground/ExitDoor/StarExitDoor, $Foreground/ExitDoor/StarExitDoor2, $Foreground/ExitDoor/StarExitDoor3, $Foreground/ExitDoor/StarExitDoor4]

var in_lever_area = false
var total_time = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$Foreground/ShortcutDoor.visible = !GameManager.USED_KEY
	$Pickups/Key.visible = !(GameManager.HAS_KEY)
	#if GameManager.USED_KEY:
		#$Colliders/ShortcutDoorCollision.free()
	if GameManager.FLICKED_LEVER:
		$Midground/TrapDoor.visible = false
		$Colliders/TrapDoorCollision.free()
		$Midground/Lever/Activated.visible = true
		$Midground/Lever/Deactivated.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var threshold = GameManager.memory_core_count + GameManager.temp_memory_core_count
	
	total_time += delta
	var alpha_for_temp = cos(total_time) 
	for i in range(DOOR_STARS.size()):
		DOOR_STARS[i].visible = threshold > i
		if (GameManager.memory_core_count <= i):
			DOOR_STARS[i].modulate.a = alpha_for_temp
	
	
	if in_lever_area:
		if Input.is_action_just_pressed("sleep") and !GameManager.FLICKED_LEVER:
			GameManager.FLICKED_LEVER = true
			$Midground/TrapDoor.visible = false
			$Colliders/TrapDoorCollision.free()
			$Midground/Lever/Activated.visible = true
			$Midground/Lever/Deactivated.visible = false

func _on_key_pickup(body: Node2D) -> void:
	if (body.name == "Player"):
		GameManager.HAS_KEY_TEMP = true
		$Pickups/Key.visible = false


func _on_key_used(body: Node2D) -> void:
	if (body.name == "Player") and GameManager.HAS_KEY or GameManager.HAS_KEY_TEMP:
		$Foreground/ShortcutDoor.visible = false
		GameManager.HAS_KEY = false
		GameManager.HAS_KEY_TEMP = false
		$Colliders/ShortcutDoorCollision.free()


func _on_exit_approach(body: Node2D) -> void:
	if (body.name == "Player") and GameManager.memory_core_count + GameManager.temp_memory_core_count >= 4:
		$Foreground/ExitDoor.free()
		$Colliders/ExitDoorCollision.free()

func _on_lever_pulled(body: Node2D) -> void:
	if (body.name == "Player"):
		in_lever_area = true


func _on_level_leave(body: Node2D) -> void:
	if (body.name == "Player"):
		in_lever_area = false
