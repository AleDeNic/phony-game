extends Area2D

@export var dialogue_resource: Resource = load("res://dialogues/window.dialogue")
@export var dialogue_start: String = "window_intro"

@onready var timer: Timer = $WindowTimer
@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var player: CharacterBody2D = %Player

# ----- INITIALIZATION AND PHYSICS -----
# ...

# ----- STATE MANAGEMENT -----

func _on_area_entered(_area: Area2D) -> void:
	timer.start()
	
	camera.set_camera_zoom(camera.window_zoom_value, camera.window_zoom_speed)
	
	StoryManager.start_dialogue(StoryManager.window_monologue, dialogue_resource, dialogue_start, self)
	PhaseManager.advance()

func _on_area_exited(_area: Area2D) -> void:
	timer.stop()
	
	camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
	if StoryManager.current_dialogue_area == self:
		StoryManager.end_dialogue()
	PlayerManager.set_player_focusing_out()
