extends Area2D

@onready var timer: Timer = $AsukaTimer
@onready var asuka_sprite: Sprite2D = $AsukaSprite
@onready var asuka_animation: AnimationPlayer = $AsukaSprite/AsukaAnimation
@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var eyes_sprite: AnimatedSprite2D = $EyesSprite
@onready var game_manager: Node2D = %GameManager
@onready var player: CharacterBody2D = %Player

var is_zooming_in: bool

@export var scale_up_speed: float = 0.2
@export var scale_down_speed: float = 1.0

func _ready() -> void:
	eyes_sprite.frame = 0

func _on_area_entered(_area: Area2D) -> void:
	timer.start()
	player.state = "asuka_zooming_in"
	game_manager.handle_timeline("asuka")
	is_zooming_in = true
	asuka_sprite.z_index = 2
	asuka_scale(scale_up_speed)
	camera.start_zoom(camera.asuka_zoom_value, camera.asuka_zoom_speed)
	await get_tree().create_timer(0.3).timeout
	eyes_sprite.frame = 1
	print("Entered Asuka area: ", game_manager.timelines)

func _on_area_exited(_area: Area2D) -> void:
	timer.stop()
	player.state = "phone_out"
	game_manager.handle_timeline("asuka", true)
	if Dialogic.Styles.get_layout_node():
		Dialogic.Styles.get_layout_node().hide()
	is_zooming_in = false
	asuka_scale(scale_down_speed)
	camera.start_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
	await get_tree().create_timer(0.3).timeout
	eyes_sprite.frame = 0
	print("Exited Asuka area: ", game_manager.timelines)

func _on_asuka_animation_animation_finished(_anim_name: StringName) -> void:
	if is_zooming_in == false:
		asuka_sprite.z_index = 0

func asuka_scale(scale_speed: float) -> void:
	asuka_animation.speed_scale = scale_speed
	if is_zooming_in:
		asuka_animation.play("scale")
	else:
		asuka_animation.play_backwards("scale")
