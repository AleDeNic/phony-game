extends Area2D

@onready var timer: Timer = $AsukaTimer
@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var eyes_sprite: AnimatedSprite2D = $EyesSprite
@onready var game_manager: Node = $"../GameManager"
@onready var dialogue_resource = preload("res://dialogues/asuka.dialogue")

func _ready() -> void:
	eyes_sprite.frame = 0

func _on_area_entered(_area: Area2D) -> void:
	game_manager.set_player_state(game_manager.PlayerState.ZOOMING_IN)
	game_manager.player.start_zoom(global_position)
	
	timer.start()
	
	camera.set_camera_zoom(camera.asuka_zoom_value, camera.asuka_zoom_speed)
	await get_tree().create_timer(0.3).timeout
	eyes_sprite.frame = 1
	start_dialogue()

func _on_area_exited(_area: Area2D) -> void:
	game_manager.set_player_state(game_manager.PlayerState.ZOOMING_OUT)
	game_manager.player.end_zoom()
	
	timer.stop()
	camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
	await get_tree().create_timer(0.3).timeout
	eyes_sprite.frame = 0
	pause_dialogue()

func start_dialogue() -> void:
	game_manager.start_dialogue(dialogue_resource, "asuka_intro")

func pause_dialogue() -> void:
	game_manager.pause_dialogue()
