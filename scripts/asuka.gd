extends Area2D

@export var dialogue_resource: Resource = load("res://dialogues/asuka.dialogue")
@export var dialogue_start: String = "asuka_intro"

@onready var timer: Timer = $AsukaTimer
@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var eyes_sprite: AnimatedSprite2D = $EyesSprite
@onready var player: CharacterBody2D = %Player

# ----- INITIALIZATION AND PHYSICS -----

func _ready() -> void:
	eyes_sprite.frame = 0

# ----- INTERACTIONS -----

func _on_area_entered(_area: Area2D) -> void:
	timer.start()
	player.target_position = Vector2(global_position)
	player.focus_speed = player.focus_speed_asuka
	PlayerManager.set_player_focusing_in()
	camera.set_camera_zoom(camera.asuka_zoom_value, camera.asuka_zoom_speed)
	StoryManager.start_dialogue(dialogue_resource, dialogue_start, self)
	get_eyes_attention()

func _on_area_exited(_area: Area2D) -> void:
	timer.stop()
	
	if StoryManager.current_dialogue_area == self:
		StoryManager.end_dialogue()
	
	camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
	get_eyes_attention()
	

# ----- UTILS -----

func get_eyes_attention() -> void:
	await get_tree().create_timer(0.3).timeout
	if PlayerManager.is_player_focusing_in():
		eyes_sprite.frame = 1
	elif PlayerManager.is_player_focusing_out():
		eyes_sprite.frame = 0
