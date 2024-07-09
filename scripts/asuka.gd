extends Area2D

@export var dialogue_resource: Resource = load("res://dialogues/asuka.dialogue")
@export var dialogue_start: String = "asuka_intro"

@onready var timer: Timer = $AsukaTimer
@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var eyes_sprite: AnimatedSprite2D = $EyesSprite
@onready var player_manager: Node = %PlayerManager
@onready var player: CharacterBody2D = %Player
@onready var story_manager: Node = %StoryManager


# ----- INITIALIZATION AND PHYSICS -----

func _ready() -> void:
	eyes_sprite.frame = 0

func _process(_delta: float) -> void:
	if story_manager.current_dialogue_area == self and not overlaps_body(player):
		story_manager.end_dialogue()


# ----- INTERACTIONS -----

func _on_area_entered(_area: Area2D) -> void:
	timer.start()
	player.target_position = Vector2(global_position)
	player.focus_speed = player.focus_speed_asuka
	player_manager.set_player_zooming_in()
	camera.set_camera_zoom(camera.asuka_zoom_value, camera.asuka_zoom_speed)
	story_manager.start_dialogue(dialogue_resource, dialogue_start, self)
	get_eyes_attention()
	#player_manager.print_player_state(player_manager.player_state)

func _on_area_exited(_area: Area2D) -> void:
	timer.stop()
	#player_manager.set_player_zooming_out()
	if story_manager.current_dialogue_area == self:
		story_manager.end_dialogue()
	camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
	get_eyes_attention()
	#player_manager.print_player_state(player_manager.player_state)
	

# ----- UTILS -----

func get_eyes_attention() -> void:
	await get_tree().create_timer(0.3).timeout
	if player_manager.get_player_state() == PlayerManager.PlayerState.ZOOMING_IN:
		eyes_sprite.frame = 1
	elif player_manager.get_player_state() == PlayerManager.PlayerState.ZOOMING_OUT:
		eyes_sprite.frame = 0
