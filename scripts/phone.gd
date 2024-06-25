extends Area2D

@onready var game_manager: Node2D = %GameManager
@onready var timer: Timer = $PhoneTimer
@onready var phone_animation: AnimationPlayer = $PhoneAnimation
@onready var effects_animation: AnimationPlayer = $"../Player/EffectsControl/EffectsAnimation"
@onready var camera: Camera2D = $"../Player/Camera2D"

var is_zooming_in: bool = false

@export_group("Scale speeds")
@export var scale_up_speed: float = 0.2
@export var scale_down_speed: float = 0.8
@export_group("Blur speeds")
@export var blur_increase_speed: float = 0.3
@export var blur_decrease_speed: float = 2.0

func _ready() -> void:
	print("Phone started")

func _on_area_entered(_area: Area2D) -> void:
	is_zooming_in = true
	timer.start()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	game_manager.brain_energy -= game_manager.multitasking_cost
	phone_scale(scale_up_speed)
	start_blur(blur_increase_speed)
	camera.start_zoom(camera.phone_zoom_value, camera.phone_zoom_speed)

func _on_area_exited(_area: Area2D) -> void:
	print("area exited")
	is_zooming_in = false
	timer.stop()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	phone_scale(scale_down_speed)
	start_blur(blur_decrease_speed)
	camera.start_zoom(camera.default_zoom_value, camera.reset_zoom_speed)

func phone_scale(scale_speed) -> void:
	phone_animation.speed_scale = scale_speed
	if is_zooming_in:
		phone_animation.play("scale")
	else:
		phone_animation.play_backwards("scale")

func start_blur(blur_speed) -> void:
	effects_animation.speed_scale = blur_speed
	if is_zooming_in:
		effects_animation.play("blur")
	else:
		effects_animation.play_backwards("blur")

#func _on_mouse_entered() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#
#func _on_mouse_exited() -> void:
	##Input.set_custom_mouse_cursor(load("res://assets/images/cursor.jpg"))
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
