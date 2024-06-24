extends Area2D

@onready var game_manager: Node2D = %GameManager
@onready var timer: Timer = $WindowTimer
@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var player: CharacterBody2D = %Player
@onready var audio_manager: Node2D = $"../AudioManager"

func _ready() -> void:
	print("Window started")

func _on_area_entered(_area: Area2D) -> void:
	timer.start()
	game_manager.brain_energy -= game_manager.multitasking_cost
	camera.start_zoom(camera.window_zoom_value, camera.window_zoom_speed)

func _on_area_exited(_area: Area2D) -> void:
	timer.stop()
	camera.start_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
