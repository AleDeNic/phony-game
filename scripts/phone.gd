extends Area2D

@export var dialogue_resource: Resource = load("res://dialogues/asuka.dialogue")
@export var dialogue_start: String = "asuka_intro"
@export var dialogue_balloon: Resource = load("res://scenes/balloons/dialogue_balloon.tscn")

@onready var phone_effects: CanvasLayer = get_node("/root/World/SceneEffects/PhoneEffects")
@onready var camera: Camera2D = get_node("/root/World/Player/Camera2D")
@onready var player: CharacterBody2D = %Player
@onready var phone_os: Control = $PhoneOS
@onready var parallax_layer: ParallaxLayer = $".."

@export_group("Scale sizes")
@export var min_scale: Vector2 = Vector2(0.7, 0.7)
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

@onready var asuka: Area2D = $"../../../Asuka"


var current_scale_speed: float = 0.0
var target_scale: Vector2 = min_scale
var current_rotation_speed: float = 0.0
var target_rotation: float = min_rotation

var is_dialogue_started: bool = false
var angry_dialogue_index: int = 0


#region Processing

func _ready() -> void:
	current_scale_speed = scale_up_speed
	current_rotation_speed = rotation_up_speed
	rotation_degrees = min_rotation
	asuka.hide()

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
	if !Player.is_free() and Notifications.is_inbox_cleared():
		exit()
	else:
		phone_os.display_cant_leave_alert()
#endregion

#region Area Handler
func enter() -> void:
	player.set_target(global_position + Vector2(0.0, -500), player.focus_speed_phone)

	Player.set_focusing_on_phone()

	camera.set_camera_zoom(camera.phone_zoom_value, camera.phone_zoom_speed)

	set_phone_scale(max_scale, scale_up_speed)
	set_phone_rotation(max_rotation, rotation_up_speed)

	phone_effects.set_effects(phone_effects.MAX_LOD, effects_increase_speed)

	if !Phone.is_discharged():
		phone_os.go_to_screen(phone_os.apps)
		phone_os.turn_on_phone_visuals()

	await get_tree().create_timer(1.0).timeout
	if Player.is_focusing_on_phone():
		Player.set_focus_on_phone()
		if Asuka.is_dialogue_inactive():
			await get_tree().create_timer(5.0).timeout
			await Asuka.set_dialogue_active()
			DialogueManager.show_dialogue_balloon_scene(-24, 0, dialogue_balloon, dialogue_resource, dialogue_start)
			Asuka.set_asuka(Asuka.Pose.A2, Asuka.Face.PLEASED, Asuka.Eyes.NORMAL)
			asuka.show()

func exit() -> void:
	player.current_speed = 0.0

	Player.set_unfocusing()
	Phone.set_phone_off()

	camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)

	set_phone_scale(min_scale, scale_down_speed)
	set_phone_rotation(min_rotation, rotation_down_speed)

	phone_effects.set_effects(phone_effects.MIN_LOD, effects_decrease_speed)
	phone_os.hide_cant_leave_alert()

	if !Phone.is_discharged():
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
		scale = clamp(new_scale, min_scale, max_scale)

func update_rotation(delta: float) -> void:
	var rotation_difference: float = wrapf(target_rotation - rotation_degrees, -180.0, 180.0)
	var rotation_step: float       = current_rotation_speed * delta

	if abs(rotation_difference) > 0.1:
		var new_rotation = rotation_degrees + sign(rotation_difference) * rotation_step
		new_rotation = clamp(new_rotation, min_rotation, max_rotation)
		rotation_degrees = new_rotation
#endregion
#func decrease_parallax() -> void:
	#parallax_layer.motion_scale = Vector2(0.0, 0.0)
#
#func increase_parallax() -> void:
	#parallax_layer.motion_scale = Vector2(0.2, 0.2)
