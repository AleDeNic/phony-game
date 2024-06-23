extends Area2D

@onready var game_manager: Node2D = %GameManager
@onready var timer: Timer = $PhoneTimer
@onready var phone_sprite: Sprite2D = $PhoneSprite
@onready var phone_animation: AnimationPlayer = $PhoneSprite/PhoneAnimation
@onready var blur_animation: AnimationPlayer = $"../Environment/Background/Blur/BlurAnimation"
@onready var distortion_animation: AnimationPlayer = $"../Environment/Background/Distortion/DistortionAnimation"
@onready var camera: Camera2D = $"../Player/Camera2D"

var is_zooming_out: bool

func _ready() -> void:
	print("Phone started")

func _on_area_entered(_area: Area2D) -> void:
	timer.start()
	is_zooming_out = false
	phone_sprite.z_index = 2
	game_manager.brain_energy -= game_manager.multitasking_cost
	phone_animation.speed_scale = 0.4
	phone_animation.play("zoom")
	blur_animation.speed_scale = 0.4
	blur_animation.play("blur")
	distortion_animation.speed_scale = 0.5
	distortion_animation.play("distortion")
	camera.start_zoom(camera.phone_zoom_value, camera.phone_zoom_speed)

func _on_area_exited(_area: Area2D) -> void:
	timer.stop()
	is_zooming_out = true
	phone_animation.speed_scale = 3
	phone_animation.play_backwards("zoom")
	blur_animation.speed_scale = 3
	blur_animation.play_backwards("blur")
	distortion_animation.play("RESET")
	camera.start_zoom(camera.default_zoom_value, camera.reset_zoom_speed)

func _on_phone_timer_timeout() -> void:
	if game_manager.attention_span < game_manager.max_attention_span:
		game_manager.attention_span += game_manager.phone_increase
	else:
		print("ATTENTION SPAN RESTORED")

func _on_phone_animation_animation_finished(_anim_name: StringName) -> void:
	if is_zooming_out:
		phone_sprite.z_index = 0



