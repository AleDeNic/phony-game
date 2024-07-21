extends Area2D

#region VARIABLES
@export var dialogue_resource: Resource = load("res://dialogues/asuka.dialogue")
@export var dialogue_start: String = "asuka_intro"
@export var dialogue_balloon: Resource = load("res://scenes/balloons/dialogue_balloon.tscn")

@onready var phone_effects: Control = get_node("/root/World/Parallax/Phone/PhoneEffects")
@onready var camera: Camera2D = get_node("/root/World/Player/Camera2D")
@onready var player: CharacterBody2D = %Player
@onready var phone_os: Control = $PhoneOS

const MIN_SCALE: Vector2 = Vector2(0.7, 0.7)
const MAX_SCALE: Vector2 = Vector2(2.0, 2.0)

const SCALE_UP_SPEED: float = 3.0
const SCALE_DOWN_SPEED: float = 3.0

const EFFECTS_INCREASE_SPEED: float = 2.5
const EFFECTS_DECREASE_SPEED: float = 3.5

const MIN_ROTATION: float = -6.0
const MAX_ROTATION: float = 0.0

const ROTATION_UP_SPEED: float = 16.0
const ROTATION_DOWN_SPEED: float = 10.0

var current_scale_speed: float = 0.0
var current_rotation_speed: float = 0.0

var target_scale: Vector2 = MIN_SCALE
var target_rotation: float = MIN_ROTATION

var is_dialogue_started: bool = false
var angry_dialogue_index: int = 0
#endregion


#region Processing
func _ready() -> void:
	current_scale_speed = SCALE_UP_SPEED
	current_rotation_speed = ROTATION_UP_SPEED
	rotation_degrees = MIN_ROTATION


func _physics_process(delta: float) -> void:
	if Player.is_focusing():
		update_scale(delta)
		update_rotation(delta)
#endregion


#region Interactions
func _on_area_entered(_area: Area2D) -> void:
	if Player.is_free() or Player.is_unfocusing() or Player.is_drifting_to_phone():
		enter()


func _on_phone_os_mouse_exited() -> void:
	if not Player.is_free() and Notifications.is_inbox_cleared():
		exit()
	else:
		phone_os.display_cant_leave_alert()
#endregion


#region Area Handler
func enter() -> void:
	player.set_target(global_position + Vector2(0.0, -500), player.PHONE_FOCUS_SPEED)

	Player.set_focusing_on_phone()

	set_phone_scale(MAX_SCALE, SCALE_UP_SPEED)
	set_phone_rotation(MAX_ROTATION, ROTATION_UP_SPEED)

	phone_effects.set_effects(phone_effects.MAX_LOD, EFFECTS_INCREASE_SPEED)

	if not Phone.is_discharged():
		phone_os.go_to_screen(phone_os.apps)
		phone_os.turn_on_phone_visuals()

	await get_tree().create_timer(1.0).timeout
	if Player.is_focusing_on_phone():
		Player.set_focus_on_phone()
		if Asuka.is_dialogue_inactive():
			await get_tree().create_timer(5.0).timeout
			await Asuka.set_dialogue_active()
			DialogueManager.show_dialogue_balloon_scene(-24, 0, dialogue_balloon, dialogue_resource, dialogue_start)


func exit() -> void:
	player.current_speed = 0.0

	Player.set_unfocusing()
	Phone.set_phone_off()

	set_phone_scale(MIN_SCALE, SCALE_DOWN_SPEED)
	set_phone_rotation(MIN_ROTATION, ROTATION_DOWN_SPEED)

	phone_effects.set_effects(phone_effects.MIN_LOD, EFFECTS_DECREASE_SPEED)
	phone_os.hide_cant_leave_alert()

	if not Phone.is_discharged():
		phone_os.reset_screens()
		phone_os.turn_off_phone_visuals()

	await get_tree().create_timer(1.0).timeout

	if Player.is_unfocusing():
		Player.set_free()
#endregion


#region Animations
func set_phone_scale(scale_value: Vector2, scale_speed: float) -> void:
	if target_scale != scale_value:
		target_scale = scale_value
		current_scale_speed = scale_speed


func set_phone_rotation(rotation_value: float, rotation_speed: float) -> void:
	if target_rotation != rotation_value:
		target_rotation = rotation_value
		current_rotation_speed = rotation_speed
#endregion


#region Scale and rotation
func update_scale(delta: float) -> void:
	var new_scale: Vector2 = scale.slerp(target_scale, current_scale_speed * delta)
	if abs((scale - new_scale).length()) > 0.001:
		scale = clamp(new_scale, MIN_SCALE, MAX_SCALE)


func update_rotation(delta: float) -> void:
	var rotation_difference: float = wrapf(target_rotation - rotation_degrees, -180.0, 180.0)
	var rotation_step: float       = current_rotation_speed * delta

	if abs(rotation_difference) > 0.1:
		var new_rotation = rotation_degrees + sign(rotation_difference) * rotation_step
		new_rotation = clamp(new_rotation, MIN_ROTATION, MAX_ROTATION)
		rotation_degrees = new_rotation
#endregion
