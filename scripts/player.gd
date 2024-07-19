extends CharacterBody2D

@onready var phone: Area2D = $"../PhoneCanvas/ParallaxLayer/Phone"

@export var default_speed: float = 70.0
@export var transition_speed: float = 10.0
@export var focus_speed_phone: float = 200.0
@export var focus_speed_asuka: float = 400.0
@export var dead_zone_radius: float = 1.0

@onready var camera: Camera2D = $"../Player/Camera2D"

var current_speed: float
var target_speed: float
var viewport: Viewport
var target_position: Vector2
var focus_speed: float


# ----- INITIALIZATION -----

func _ready() -> void:
	add_to_group("player")
	setup_viewport()
	current_speed = default_speed
	focus_speed = focus_speed_phone


func _physics_process(_delta: float) -> void:
	check_viewport()
	update_player(_delta)


## ----- MOVEMENT -----

func handle_movement(delta: float) -> void:
	var movement_vector: Vector2 = get_movement_input()
	target_speed = default_speed
	reset_mouse_to_center()
	current_speed = lerp(current_speed, target_speed, delta * transition_speed)
	velocity = velocity.lerp(movement_vector * current_speed, delta * transition_speed)
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
	target_speed = default_speed
	move(delta, movement_vector)
	reset_mouse_to_center()


func move(delta: float, movement_vector: Vector2) -> void:
	current_speed = lerp(current_speed, target_speed, delta * transition_speed)
	velocity = velocity.lerp(movement_vector * current_speed, delta * transition_speed)
	move_and_slide()


func set_target(target_global_position: Vector2, speed: float) -> void:
	target_position = Vector2(target_global_position)
	focus_speed = speed


## ----- INPUT -----

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


# ----- UTILS -----

func setup_viewport() -> void:
	viewport = get_viewport()
	if viewport:
		reset_mouse_to_center()


func check_viewport() -> void:
	if not viewport:
		setup_viewport()
		return


func update_player(_delta: float) -> void:
	match Player.get_state():
		Player.is_focusing_on_asuka(), Player.is_focused_on_asuka():
			camera.set_camera_zoom(camera.asuka_zoom_value, camera.asuka_zoom_speed)
			handle_movement(_delta)
		Player.is_focusing_on_phone(), Player.is_focused_on_phone():
			camera.set_camera_zoom(camera.phone_zoom_value, camera.phone_zoom_speed)
			focus(_delta)
		Player.is_free(), Player.is_unfocusing():
			camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
			target_speed = 0.0
			current_speed = 0.0
			velocity = Vector2.ZERO
		Player.is_dialogue_paused():
			pass
