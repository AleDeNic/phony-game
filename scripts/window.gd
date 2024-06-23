extends Area2D

@onready var game_manager: Node2D = %GameManager
@onready var timer: Timer = $WindowTimer
@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var blur_animation: AnimationPlayer = $"../Environment/Background/Blur/BlurAnimation"
@onready var player: CharacterBody2D = %Player
@onready var audio_manager: Node2D = $"../AudioManager"

func _ready() -> void:
	print("Window started")

func _on_area_entered(_area: Area2D) -> void:
	timer.start()
	#player.attract_to_window()
	game_manager.brain_energy -= game_manager.multitasking_cost
	#blur_animation.speed_scale = 0.4
	#blur_animation.play("blur")
	camera.start_zoom_window()

func _on_area_exited(_area: Area2D) -> void:
	timer.stop()
	print("Attention span: ", game_manager.attention_span)
	print("Brain energy: ", game_manager.brain_energy)
	#blur_animation.speed_scale = 3
	#blur_animation.play_backwards("blur")
	camera.reset_zoom()

func _on_window_timer_timeout() -> void:
	if game_manager.attention_span > 0.0:
		game_manager.attention_span -= game_manager.window_decrease
