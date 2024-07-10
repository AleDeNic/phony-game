extends Area2D

@onready var timer: Timer = $PhoneTimer
@onready var effects: Control = $"../Effects"
@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var player: CharacterBody2D = %Player
@onready var phone_os: Control = $PhoneOS

@export_group("Scale sizes")
@export var min_scale: Vector2 = Vector2(1.0, 1.0)
@export var max_scale: Vector2 = Vector2(2.0, 2.0)

@export_group("Scale speeds")
@export var scale_up_speed: float = 3.0
@export var scale_down_speed: float = 3.0

@export_group("Effects speeds")
@export var effects_increase_speed: float = 2.5
@export var effects_decrease_speed: float = 3.5

@export_group("Rotation angles")
@export var min_rotation: float = -6.0
@export var max_rotation: float = 0.0

@export_group("Rotation speeds")
@export var rotation_up_speed: float = 16.0
@export var rotation_down_speed: float = 10.0

var current_scale_speed: float = 0.0
var target_scale: Vector2 = min_scale
var current_rotation_speed: float = 0.0
var target_rotation: float = min_rotation


# ----- INITIALIZATION AND PHYSICS -----

func _ready() -> void:
	current_scale_speed = scale_up_speed
	current_rotation_speed = rotation_up_speed
	rotation_degrees = min_rotation

func _physics_process(delta: float) -> void:
	if PlayerManager.is_player_focusing():
		update_scale(delta)
		update_rotation(delta)
		update_player_state()


# --------- PHONE INTERACTIONS -----------

func _on_area_entered(_area: Area2D) -> void:
	if PlayerManager.is_player_free():
		enter_phone()

func _on_phone_os_mouse_exited() -> void:
	if !PlayerManager.is_player_free():
		exit_phone()

func enter_phone() -> void:
	
	player.target_position = Vector2(global_position)
	player.focus_speed = player.focus_speed_phone
	PlayerManager.set_player_focusing_in()
	# TODO: Change this change this change this change this change this change this change this change this change this change this change this change this 
	phone_os.restore_phone_state()
	timer.start()
	
	camera.set_camera_zoom(camera.phone_zoom_value, camera.phone_zoom_speed)
	
	set_phone_scale(max_scale, scale_up_speed)
	set_phone_rotation(max_rotation, rotation_up_speed)
	
	effects.set_effects(effects.MAX_LOD, effects_increase_speed)

func exit_phone() -> void:
	PlayerManager.set_player_focusing_out()
	timer.stop()
	PhoneManager.set_phone_off()
	
	camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
	set_phone_scale(min_scale, scale_down_speed)
	set_phone_rotation(min_rotation, rotation_down_speed)
	
	effects.set_effects(effects.MIN_LOD, effects_decrease_speed)


# ----- SET ANIMATIONS -----

func set_phone_scale(scale_value: Vector2, scale_speed: float) -> void:
	if target_scale != scale_value:
		target_scale = scale_value
		current_scale_speed = scale_speed

func set_phone_rotation(rotation_value: float, rotation_speed: float) -> void:
	if target_rotation != rotation_value:
		target_rotation = rotation_value
		current_rotation_speed = rotation_speed


# ----- UPDATE SCALE & ROTATION -----

func update_scale(delta: float) -> void:
	var new_scale: Vector2 = scale.slerp(target_scale, current_scale_speed * delta)
	if abs((scale - new_scale).length()) > 0.001:
		scale = clamp(new_scale, min_scale, max_scale)

func update_rotation(delta: float) -> void:
	var rotation_difference: float = wrapf(target_rotation - rotation_degrees, -180.0, 180.0)
	var rotation_step: float       = current_rotation_speed * delta
	
	if abs(rotation_difference) > 0.1:
		var new_rotation = rotation_degrees + sign(rotation_difference) * rotation_step
		new_rotation = clamp(new_rotation, min_rotation, max_rotation)
		rotation_degrees = new_rotation


# ----- STATE MANAGEMENT -----

func update_player_state() -> void:
	if abs(scale.x - target_scale.x) < 0.1:
		if PlayerManager.is_player_focusing_out():
			PlayerManager.set_player_free()
