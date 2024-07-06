extends Area2D

# ISSUE: scale and effects are interrupted when you move too fast
# towards asuka, chenging the player.state

@onready var game_manager: Node2D = %GameManager
@onready var timer: Timer = $PhoneTimer
@onready var black_screen: ColorRect = $"../Phone/PhoneOS/PhoneSize/BlackScreen"
@onready var effects: Control = $"../Effects"
@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var phone_os: Control = $PhoneOS
@onready var player: CharacterBody2D = %Player

@export_group("Scale sizes")
@export var min_scale: Vector2 = Vector2(1.0, 1.0)
@export var max_scale: Vector2 = Vector2(2.0, 2.0)
@export_group("Scale speeds")
@export var scale_up_speed: float = 3.0
@export var scale_down_speed: float = 3.0
@export_group("Effects speeds")
@export var effects_increase_speed: float = 2.5
@export var effects_decrease_speed: float = 3.5

var current_scale_speed: float = 0.0
var target_scale: Vector2 = min_scale

func _ready() -> void:
	black_screen.visible = false
	current_scale_speed = scale_up_speed

func _process(delta: float) -> void:
	if player.state in ["phone_zooming_in", "phone_zooming_out"]:
		update_scale(delta)
		update_player_state()

func update_scale(delta: float) -> void:
	var new_scale = scale.slerp(target_scale, current_scale_speed * delta)
	if (scale - new_scale).length() > 0.001:
		new_scale = clamp(new_scale, min_scale, max_scale)
		scale = new_scale

func update_player_state() -> void:
	if abs(scale.x - target_scale.x) < 0.1:
		if player.state == "phone_zooming_in":
			player.state = "phone"
		elif player.state == "phone_zooming_out":
			player.state = "free"

func set_phone_scale(scale_value: Vector2, scale_speed: float) -> void:
	if target_scale != scale_value:
		target_scale = scale_value
		current_scale_speed = scale_speed

func _on_area_entered(_area: Area2D) -> void:
	if player.state == "free":
		enter_phone()
		phone_os.phone_state = "Apps"

func enter_phone() -> void:
	player.state = "phone_zooming_in"
	timer.start()
	set_phone_scale(max_scale, scale_up_speed)
	effects.set_effects(effects.max_lod, effects_increase_speed)
	camera.set_camera_zoom(camera.phone_zoom_value, camera.phone_zoom_speed)

func exit_phone() -> void:
	player.state = "phone_zooming_out"
	timer.stop()
	set_phone_scale(min_scale, scale_down_speed)
	effects.set_effects(effects.min_lod, effects_decrease_speed)
	camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
