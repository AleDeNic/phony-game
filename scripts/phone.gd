extends Area2D

@onready var phone_effects: CanvasLayer = get_node("/root/World/SceneEffects/PhoneEffects")
@onready var camera: Camera2D = get_node("/root/World/Player/Camera2D")
@onready var player: CharacterBody2D = %Player
@onready var phone_os: Control = $PhoneOS
@export var dialogue_start: String = "angry_asuka_intro"

@export_group("Scale sizes")
@export var min_scale: Vector2 = Vector2(0.7, 0.7)
@export var max_scale: Vector2 = Vector2(1.8, 1.8)

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

var is_dialogue_started: bool = false
var angry_dialogue_index: int = 0


# ----- INITIALIZATION AND PHYSICS -----

func _ready() -> void:	
	current_scale_speed = scale_up_speed
	current_rotation_speed = rotation_up_speed
	rotation_degrees = min_rotation

func _physics_process(delta: float) -> void:
	if PlayerManager.is_player_focusing():
		update_scale(delta)
		update_rotation(delta)


# --------- PHONE INTERACTIONS -----------

func _on_area_entered(_area: Area2D) -> void:
	if PlayerManager.is_player_free() or PlayerManager.is_player_focusing_out():
		enter_phone()

func _on_phone_os_mouse_exited() -> void:
	if !PlayerManager.is_player_free() and NotificationsManager.are_notifications_cleared:
		exit()
	else:
		phone_os.display_cant_leave_alert()

func enter_phone() -> void:
	player.set_focus_target(global_position, player.focus_speed_phone)

	PlayerManager.set_player_focusing_on_phone()

	camera.set_camera_zoom(camera.phone_zoom_value, camera.phone_zoom_speed)

	set_phone_scale(max_scale, scale_up_speed)
	set_phone_rotation(max_rotation, rotation_up_speed)

	phone_effects.set_effects(phone_effects.MAX_LOD, effects_increase_speed)
	
	if !PhoneManager.is_phone_discharged():
		phone_os.go_to_screen(phone_os.apps)
	
	if PhaseManager.can_dialogue_spawn():
		start_angry_dialogue()
	
	await get_tree().create_timer(1.0).timeout
	if PlayerManager.is_player_focusing_on_phone():
		PlayerManager.set_player_focused_phone()

func exit() -> void:
	player.current_speed = 0.0

	PlayerManager.set_player_focusing_out()
	PhoneManager.set_phone_off()

	camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)

	set_phone_scale(min_scale, scale_down_speed)
	set_phone_rotation(min_rotation, rotation_down_speed)

	phone_effects.set_effects(phone_effects.MIN_LOD, effects_decrease_speed)
	phone_os.hide_cant_leave_alert()

	if !PhoneManager.is_phone_discharged():
		phone_os.reset_screens()

	await get_tree().create_timer(1.0).timeout
	
	if PlayerManager.is_player_focusing_out():
		PlayerManager.set_player_free()

func start_angry_dialogue() -> void:
	var dialogue_path: String = "res://dialogues/angry_asuka_%d.dialogue" % angry_dialogue_index
	var dialogue_resource = load(dialogue_path)
	
	if dialogue_resource:
		StoryManager.start_dialogue(StoryManager.dialogue_balloon, dialogue_resource, dialogue_start, self, true)
		angry_dialogue_index += 1
	else:
		print("Dialogue resource not found: ", dialogue_path)


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
