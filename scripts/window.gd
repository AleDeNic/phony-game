extends Area2D

@export var dialogue_resource: Resource = load("res://dialogues/window.dialogue")
@export var dialogue_start: String = "window_intro"

@onready var timer: Timer = $WindowTimer
@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var game_manager: Node = $"../GameManager"

# ----- INITIALIZATION AND PHYSICS -----
func _process(_delta: float) -> void:
	if game_manager.current_dialogue_area == self and not overlaps_body(game_manager.player):
		game_manager.end_dialogue()

func _on_area_entered(_area: Area2D) -> void:
		game_manager.set_player_state(game_manager.PlayerState.ZOOMING_IN)
		game_manager.player.start_zoom(global_position)
		
		timer.start()
		camera.set_camera_zoom(camera.window_zoom_value, camera.window_zoom_speed)
		
		game_manager.start_dialogue(dialogue_resource, dialogue_start, self)

# ----- STATE MANAGEMENT -----
func _on_area_exited(_area: Area2D) -> void:
		if game_manager.current_dialogue_area == self:
			game_manager.end_dialogue()
		
		game_manager.set_player_state(game_manager.PlayerState.ZOOMING_OUT)
		game_manager.player.end_zoom()
		
		timer.stop()
		camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)

