extends Area2D

@onready var timer: Timer = $WindowTimer
@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var game_manager: Node2D = %GameManager

var is_zooming_in: bool

func _on_area_entered(_area: Area2D) -> void:
	timer.start()
	game_manager.handle_timeline("window")
	is_zooming_in = true
	camera.start_zoom(camera.window_zoom_value, camera.window_zoom_speed)

func _on_area_exited(_area: Area2D) -> void:
	timer.stop()
	game_manager.handle_timeline("window")
	is_zooming_in = false
	camera.start_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
