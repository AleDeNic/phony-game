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

@export_group("Scale sizes")
@export var min_scale: float = 1.0
@export var max_scale: float = 1.7
@export_group("Scale speeds")
@export var scale_up_speed: float = 1.0
@export var scale_down_speed: float = 2.0
@export_group("Effects speeds")
@export var effects_increase_speed: float = 1.0
@export var effects_decrease_speed: float = 2.0

var current_scale_speed: float
var target_scale: Vector2

func _ready() -> void:
	black_screen.visible = false
	#current_scale_speed = min_scale
	#target_scale = Vector2(current_scale_speed, current_scale_speed)
	
#func _process(delta) -> void:
	#scale = scale.lerp(target_scale, current_scale_speed * delta)
	#clamp(scale, Vector2(min_scale, min_scale), Vector2(max_scale, max_scale))
	#if abs(current_scale_speed - min_scale) < 0.01:
		#player.state = "free"
	#elif abs(current_scale_speed - max_scale) < 0.01:
		#player.state = "phone"
	##print(player.state)
	#print(current_scale_speed)

func _on_area_entered(_area: Area2D) -> void:
	if player.state == "free":
		enter_phone()

func phone_scale(scale_speed) -> void:
	phone_animation.speed_scale = scale_speed
	if player.state == "phone_zooming_in":
		phone_animation.play("scale")
		#target_scale = Vector2(max_scale, max_scale)
	elif player.state == "phone_zooming_out":
		phone_animation.play_backwards("scale")
		#target_scale = Vector2(min_scale, min_scale)

func enter_phone() -> void:
	player.object_position = position
	player.state = "phone_zooming_in"
	print(player.state)
	timer.start()
	phone_scale(scale_up_speed)
	effects.start_effects(effects_increase_speed)
	camera.start_zoom(camera.phone_zoom_value, camera.phone_zoom_speed)

func exit_phone() -> void:
	player.state = "phone_zooming_out"
	print(player.state)
	timer.stop()
	phone_scale(scale_down_speed)
	effects.start_effects(effects_decrease_speed)
	camera.start_zoom(camera.default_zoom_value, camera.reset_zoom_speed)

func _on_phone_animation_animation_finished(_anim_name: StringName) -> void:
	if player.state == "phone_zooming_in":
		player.state = "phone"
	elif player.state == "phone_zooming_out":
		player.state = "free"
