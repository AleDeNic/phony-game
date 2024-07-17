extends Area2D

@export var dialogue_resource: Resource = load("res://dialogues/asuka.dialogue")
@export var dialogue_start: String = "asuka_intro"

@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var player: CharacterBody2D = %Player

#@onready var mood: AsukaMoods = AsukaMoods.NEUTRAL
#
#enum AsukaMoods {
	#NEUTRAL,
	#HAPPY,
	#SAD,
	#ANGRY
#}

var is_dialogue_started: bool = false

# ----- INTERACTIONS -----

func _on_area_entered(_area: Area2D) -> void:
	if PlayerManager.is_player_free() or PlayerManager.is_player_focusing_out():
		enter_asuka()

func enter_asuka() -> void:
	player.set_focus_target(global_position, player.focus_speed_asuka)
	PlayerManager.set_player_focusing_on_asuka()

	if !is_dialogue_started:
		StoryManager.start_dialogue(StoryManager.dialogue_balloon, dialogue_resource, dialogue_start, self, false)
		is_dialogue_started = true
	await get_tree().create_timer(1.0).timeout
	if PlayerManager.is_player_focusing_on_asuka():
		PlayerManager.set_player_focused_asuka()

func exit() -> void:
	PlayerManager.set_player_focusing_out()
	camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)

	await get_tree().create_timer(1.0).timeout
	if PlayerManager.is_player_focusing_out():
		PlayerManager.set_player_free()
