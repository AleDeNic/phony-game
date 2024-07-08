extends Area2D

@export var dialogue_resource: Resource = load("res://dialogues/window.dialogue")
@export var dialogue_start: String = "window_intro"

@onready var phase_manager: PhaseManager = %PhaseManager

@onready var timer: Timer = $WindowTimer
@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var player_manager: Node = %PlayerManager
@onready var player: CharacterBody2D = %Player
@onready var story_manager: Node = %StoryManager


# ----- INITIALIZATION AND PHYSICS -----
func _physics_process(_delta: float) -> void:
	if story_manager.current_dialogue_area == self and not overlaps_body(story_manager.player):
		story_manager.end_dialogue()


# ----- STATE MANAGEMENT -----
func _on_area_entered(_area: Area2D) -> void:
	timer.start()
	camera.set_camera_zoom(camera.window_zoom_value, camera.window_zoom_speed)
	story_manager.start_dialogue(dialogue_resource, dialogue_start, self)
	phase_manager.go_to_next_phase(phase_manager.get_phase())

func _on_area_exited(_area: Area2D) -> void:
	if story_manager.current_dialogue_area == self:
		story_manager.end_dialogue()
	player_manager.set_player_zooming_out()
	timer.stop()
	camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)

