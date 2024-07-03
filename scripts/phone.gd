extends Area2D

@onready var game_manager: Node2D = %GameManager
@onready var timer: Timer = $PhoneTimer
@onready var black_screen: ColorRect = $"../Phone/PhoneScreen/PhoneSize/BlackScreen"
@onready var phone_animation: AnimationPlayer = $PhoneAnimation
@onready var effects_animation: AnimationPlayer = $"../Effects/EffectsAnimation"
@onready var effects: Control = $"../Effects"
@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var phone_screen: Control = $PhoneScreen
@onready var player: CharacterBody2D = %Player

@export_group("Scale speeds")
@export var scale_up_speed: float = 1.0
@export var scale_down_speed: float = 2.0
@export_group("Effects speeds")
@export var effects_increase_speed: float = 1.0
@export var effects_decrease_speed: float = 2.0

func _ready() -> void:
	effects.z_index = 1
	black_screen.visible = true

func _on_area_entered(_area: Area2D) -> void:
	if player.state == "free":
		enter_phone()
		black_screen.visible = false

func phone_scale(scale_speed) -> void:
	phone_animation.speed_scale = scale_speed
	if player.state == "phone_zooming_in":
		phone_animation.play("scale")
	elif player.state == "phone_zooming_out":
		phone_animation.play_backwards("scale")

func enter_phone() -> void:
	phone_screen.MOUSE_FILTER_PASS
	player.state = "phone_zooming_in"
	timer.start()
	phone_screen.phone_state = "home"
	phone_screen.go_to_screen("home")
	phone_scale(scale_up_speed)
	effects.start_effects(effects_increase_speed)
	camera.start_zoom(camera.phone_zoom_value, camera.phone_zoom_speed)

func exit_phone() -> void:
	phone_screen.MOUSE_FILTER_IGNORE
	player.state = "phone_zooming_out"
	timer.stop()
	phone_screen.phone_state = "off"
	phone_scale(scale_down_speed)
	effects.start_effects(effects_decrease_speed)
	camera.start_zoom(camera.default_zoom_value, camera.reset_zoom_speed)

func _on_phone_animation_animation_finished(anim_name: StringName) -> void:
	if player.state == "phone_zooming_in":
		player.state = "phone"
	elif player.state == "phone_zooming_out":
		player.state = "free"
		black_screen.visible = true
