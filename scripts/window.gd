extends Area2D

@onready var timer: Timer = $WindowTimer
@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var dialogue_display: Control = $"../DialogueManager/DialogueDisplay"

var is_zooming_in: bool

func _ready() -> void:
	print("Window started")

func _on_area_entered(_area: Area2D) -> void:
	timer.start()
	is_zooming_in = true
	dialogue_display.dialogues_visibility(is_zooming_in)
	camera.start_zoom(camera.window_zoom_value, camera.window_zoom_speed)

func _on_area_exited(_area: Area2D) -> void:
	timer.stop()
	is_zooming_in = false
	dialogue_display.dialogues_visibility(is_zooming_in)
	camera.start_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
