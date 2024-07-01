extends Area2D

@onready var game_manager: Node2D = %GameManager
@onready var timer: Timer = $PhoneTimer
@onready var black_screen: ColorRect = $"../Phone/PhoneScreen/BlackScreen"
@onready var phone_animation: AnimationPlayer = $PhoneAnimation
@onready var effects_animation: AnimationPlayer = $"../Effects/EffectsAnimation"
@onready var effects: Control = $"../Effects"
@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var phone_screen: Control = $PhoneScreen

var is_zooming_in: bool = false

@export_group("Scale speeds")
@export var scale_up_speed: float = 1.0
@export var scale_down_speed: float = 2.0
@export_group("Effects speeds")
@export var effects_increase_speed: float = 0.6
@export var effects_decrease_speed: float = 2.0

func _ready() -> void:
	effects.z_index = 1
	black_screen.visible = true

func _on_area_entered(_area: Area2D) -> void:
	is_zooming_in = true
	timer.start()
	phone_screen.phone_state = "home"
	phone_screen.go_to_screen("home")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	phone_scale(scale_up_speed)
	effects.start_effects(effects_increase_speed)
	camera.start_zoom(camera.phone_zoom_value, camera.phone_zoom_speed)
	black_screen.visible = false

func _on_area_exited(_area: Area2D) -> void:
	print("area exited")
	is_zooming_in = false
	timer.stop()
	phone_screen.phone_state = "off"
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	phone_scale(scale_down_speed)
	effects.start_effects(effects_decrease_speed)
	camera.start_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
	black_screen.visible = true

func phone_scale(scale_speed) -> void:
	phone_animation.speed_scale = scale_speed
	if is_zooming_in:
		phone_animation.play("scale")
	else:
		phone_animation.play_backwards("scale")
