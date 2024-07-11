extends CharacterBody2D

@onready var phone: Area2D = $"../Phone"

@export var default_speed: float = 70.0
@export var transition_speed: float = 10.0
@export var focus_speed_phone: float = 400.0
@export var focus_speed_asuka: float = 600.0
@export var dead_zone_radius: float = 1.0
@onready var camera: Camera2D = $"../Player/Camera2D"


var current_speed: float
var target_speed: float
var viewport: Viewport
var target_position: Vector2
var focus_speed: float


# ----- INITIALIZATION -----

func _ready() -> void:
	setup_viewport()

	current_speed = default_speed
	focus_speed = focus_speed_phone

func _physics_process(delta: float) -> void:
	check_viewport()
	#print(current_speed)

	match PlayerManager.get_player_state():
		PlayerManager.PlayerState.FREE:
			handle_free_movement(delta)
		PlayerManager.PlayerState.FOCUSING_ON_PHONE, PlayerManager.PlayerState.FOCUSING_ON_ASUKA:
			focus(delta)
		PlayerManager.PlayerState.FOCUSING_OUT:
			focus_out(delta)
		PlayerManager.PlayerState.FOCUSED_PHONE, PlayerManager.PlayerState.FOCUSED_ASUKA:
			target_speed = 0.0


# ----- INPUT & MOVEMENT -----

func handle_free_movement(delta: float) -> void:
	var movement_vector: Vector2 = get_movement_input()
	target_speed = default_speed
	reset_mouse_to_center()
	move_player(delta, movement_vector)

func focus(delta: float) -> void:
	var movement_vector: Vector2 = (target_position - global_position).normalized()
	if global_position.distance_to(target_position) >= 10.0:
		target_speed = focus_speed
		move_player(delta, movement_vector)
	else:
		current_speed = 0.0
		if PlayerManager.is_player_focusing_on_phone():
			PlayerManager.set_player_focused_phone()
		elif PlayerManager.is_player_focusing_on_asuka():
			PlayerManager.set_player_focused_asuka()

func focus_out(delta: float) -> void:
	# to fix the high initial movement vector when you exit the dialogue
	var movement_vector: Vector2 = get_movement_input()
	target_speed = default_speed
	move_player(delta, movement_vector)
	reset_mouse_to_center()
	if !camera.is_zooming:
		PlayerManager.set_player_free()

func move_player(delta: float, movement_vector: Vector2) -> void:
	current_speed = lerp(current_speed, target_speed, delta * transition_speed)
	velocity = movement_vector * current_speed
	move_and_slide()


# ----- INPUT & MOUSE-----

func get_movement_input() -> Vector2:
	if not viewport:
		return Vector2.ZERO
	var mouse_pos: Vector2 = viewport.get_mouse_position()
	var center: Vector2 = viewport.get_visible_rect().size / 2
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
