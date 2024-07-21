extends CharacterBody2D

@onready var phone: Area2D = $"../Parallax/Phone/Phone"
@onready var control: Control = $Control
@onready var camera: Camera2D = $Camera2D

const DEFAULT_SPEED: float = 140.0
const TRANSITION_SPEED: float = 10.0
const DRIFT_TO_PHONE_SPEED: float = 100
const PHONE_FOCUS_SPEED: float = 200.0
const ASUKA_FOCUS_SPEED: float = 400.0

@export_group("Other")
@export var mouse_sensitivity: float = 0.5
@export var dead_zone_radius: float = 1.0


var current_speed: float
var target_speed: float
var viewport: Viewport
var target_position: Vector2
var focus_speed: float


#region INITIALIZATION
func _ready() -> void:
	add_to_group("player")
	setup_viewport()
	current_speed = DEFAULT_SPEED
	focus_speed = PHONE_FOCUS_SPEED
	control.hide()

func _process(delta: float) -> void:
	check_viewport()
	update_camera(delta)
	move_player(delta)
#endregion


#region MOVEMENT
func move_player(delta: float):
	match Player.get_state():
		Player.State.FREE:
			free_up(delta)
		Player.State.FOCUSING_ON_PHONE, Player.State.FOCUSING_ON_ASUKA:
			focus(delta)
		Player.State.FOCUSING_OUT:
			unfocus(delta)
		Player.State.DIALOGUE_PAUSED:
			pass
		Player.State.DRIFTING_TO_PHONE:
			drift_to_phone(delta)


func free_up(delta: float) -> void:
	var movement_vector: Vector2 = get_movement_input()
	target_speed = DEFAULT_SPEED * mouse_sensitivity
	reset_mouse_to_center()
	current_speed = lerp(current_speed, target_speed, delta * TRANSITION_SPEED)
	velocity = velocity.lerp(movement_vector * current_speed, delta * TRANSITION_SPEED)
	move_and_slide()


func focus(delta: float) -> void:
	var movement_vector: Vector2 = (target_position - global_position).normalized()
	if global_position.distance_to(target_position) >= 5.0:
		target_speed = focus_speed
		move(delta, movement_vector)
	else:
		current_speed = 0.0


func unfocus(delta: float) -> void:
	var movement_vector: Vector2 = get_movement_input()
	target_speed = DEFAULT_SPEED * mouse_sensitivity
	move(delta, movement_vector)
	reset_mouse_to_center()


func move(delta: float, movement_vector: Vector2) -> void:
	current_speed = lerp(current_speed, target_speed, delta * TRANSITION_SPEED)
	velocity = velocity.lerp(movement_vector * current_speed, delta * TRANSITION_SPEED)
	move_and_slide()


func set_target(target_global_position: Vector2, speed: float) -> void:
	target_position = Vector2(target_global_position)
	focus_speed = speed


func drift_to_phone(delta: float) -> void:
	var movement_vector: Vector2 = get_movement_input()
	var attraction_vector: Vector2 = Vector2.ZERO
	var drift_multiplier: float = Notifications.notifications_amount * 0.3

	if movement_vector.length() < 0.1:
		attraction_vector = (phone.global_position - global_position).normalized()
		current_speed = lerp(current_speed, DRIFT_TO_PHONE_SPEED * drift_multiplier, delta * TRANSITION_SPEED)
		velocity = velocity.lerp(attraction_vector * current_speed, delta * TRANSITION_SPEED)
	else:
		reset_mouse_to_center()
		current_speed = lerp(current_speed, DEFAULT_SPEED * mouse_sensitivity, delta * TRANSITION_SPEED)
		velocity = velocity.lerp(movement_vector * current_speed, delta * TRANSITION_SPEED)
	
	move_and_slide()
	# print("Drift speed: ", current_speed)
#endregion

#region INPUT
func get_movement_input() -> Vector2:
	if not viewport:
		return Vector2.ZERO
	var mouse_pos: Vector2       = viewport.get_mouse_position()
	var center: Vector2          = viewport.get_visible_rect().size / 2
	var movement_vector: Vector2 = mouse_pos - center
	
	if movement_vector.length() < dead_zone_radius:
		return Vector2.ZERO
	else:
		return movement_vector


func reset_mouse_to_center() -> void:
	if viewport:
		viewport.warp_mouse(viewport.get_visible_rect().size / 2)
#endregion


#region UTILS
func setup_viewport() -> void:
	viewport = get_viewport()
	if viewport:
		reset_mouse_to_center()


func check_viewport() -> void:
	if not viewport:
		setup_viewport()
		return


func update_camera(delta: float) -> void:
	if Player.is_focusing_on_asuka() or Player.is_focused_on_asuka():
		camera.set_camera_zoom(camera.ASUKA_ZOOM_VALUE, camera.ASUKA_ZOOM_SPEED)
	elif Player.is_focusing_on_phone() or Player.is_focused_on_phone():
		camera.set_camera_zoom(camera.PHONE_ZOOM_VALUE, camera.PHONE_ZOOM_SPEED)
	elif Player.is_free() or Player.is_unfocusing():
		camera.set_camera_zoom(camera.DEFAULT_ZOOM_VALUE, camera.RESET_ZOOM_SPEED)
	elif Player.is_dialogue_paused():
		pass
#endregion
