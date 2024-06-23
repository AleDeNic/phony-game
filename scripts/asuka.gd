extends Area2D

@onready var game_manager: Node2D = %GameManager
@onready var timer: Timer = $AsukaTimer
@onready var asuka_sprite: Sprite2D = $AsukaSprite
@onready var asuka_animation: AnimationPlayer = $AsukaSprite/AsukaAnimation
@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var player: CharacterBody2D = %Player
@onready var audio_manager: Node2D = $"../AudioManager"

var is_zooming_out: bool

func _ready() -> void:
	print("Asuka started")

func _on_area_entered(_area: Area2D) -> void:
	timer.start()
	#player.attract_to_asuka()
	is_zooming_out = false
	asuka_sprite.z_index = 2
	game_manager.brain_energy -= game_manager.multitasking_cost
	asuka_animation.speed_scale = 0.2
	asuka_animation.play("zoom")
	camera.start_zoom(camera.asuka_zoom_value, camera.asuka_zoom_speed)

func _on_area_exited(_area: Area2D) -> void:
	timer.stop()
	is_zooming_out = true
	asuka_animation.speed_scale = 1
	asuka_animation.play_backwards("zoom")
	camera.start_zoom(camera.default_zoom_value, camera.reset_zoom_speed)

func _on_asuka_timer_timeout() -> void:
	if game_manager.attention_span > 0.0:
		game_manager.attention_span -= game_manager.asuka_decrease

func _on_asuka_animation_animation_finished(_anim_name: StringName) -> void:
	if is_zooming_out:
		asuka_sprite.z_index = 0
