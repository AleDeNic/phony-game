extends Area2D

@onready var game_manager: Node2D = %GameManager
@onready var timer: Timer = $PhoneTimer
@onready var phone_sprite: Sprite2D = $PhoneSprite
@onready var phone_animation: AnimationPlayer = $PhoneSprite/PhoneAnimation
@onready var effects_animation: AnimationPlayer = $"../Player/EffectsControl/EffectsAnimation"
@onready var camera: Camera2D = $"../Player/Camera2D"

var is_zooming_out: bool

@export var scale_up_speed: float = 0.4
@export var scale_down_speed: float = 4.0

func _ready() -> void:
	print("Phone started")

func _on_area_entered(_area: Area2D) -> void:
	is_zooming_out = false
	timer.start()
	phone_sprite.z_index = 2
	game_manager.brain_energy -= game_manager.multitasking_cost
	phone_scale(scale_up_speed)
	effects_animation.speed_scale = 0.2
	effects_animation.play("blur")
	camera.start_zoom(camera.phone_zoom_value, camera.phone_zoom_speed)

func _on_area_exited(_area: Area2D) -> void:
	is_zooming_out = true
	timer.stop()
	phone_scale(scale_down_speed)
	effects_animation.speed_scale = 3
	effects_animation.play_backwards("blur")
	camera.start_zoom(camera.default_zoom_value, camera.reset_zoom_speed)

func _on_phone_animation_animation_finished(_anim_name: StringName) -> void:
	if is_zooming_out:
		phone_sprite.z_index = 0

func phone_scale(scale_speed) -> void:
	phone_animation.speed_scale = scale_speed
	if is_zooming_out:
		phone_animation.play_backwards("zoom")
	else:
		phone_animation.play("zoom")
