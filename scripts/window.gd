extends Area2D

@export var dialogue_resource: Resource = load("res://dialogues/window.dialogue")
@export var dialogue_start: String = "window_intro"

@onready var camera: Camera2D = $"../Player/Camera2D"

# ----- INITIALIZATION AND PHYSICS -----
# ...

# ----- STATE MANAGEMENT -----

func _on_area_entered(_area: Area2D) -> void:
	camera.set_camera_zoom(camera.window_zoom_value, camera.window_zoom_speed)
	StoryManager.start_dialogue(StoryManager.asuka_dialogue, dialogue_resource, dialogue_start, self)
	PhaseManager.advance()

func _on_area_exited(_area: Area2D) -> void:
	camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
	PlayerManager.set_player_focusing_out()
