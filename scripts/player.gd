extends CharacterBody2D

@onready var player_manager: Node = %PlayerManager
@onready var phone: Area2D = $"../Phone"

@export var default_speed: float = 65.0
@export var transition_speed: float = 5.0
@export var focus_speed: float = 500.0
@export var exit_speed: float = 30.0
@export var dead_zone_radius: float = 1.0

var current_speed: float
var target_speed: float
var viewport: Viewport
var target_position: Vector2


# ----- INITIALIZATION -----

func _ready() -> void:
	setup_viewport()
	current_speed = default_speed

func _physics_process(delta: float) -> void:
	check_viewport()
	match player_manager.get_player_state():
		PlayerManager.PlayerState.FREE:
			handle_free_movement(delta)
		PlayerManager.PlayerState.ZOOMING_IN:
			handle_zooming_in(delta)
		PlayerManager.PlayerState.ZOOMING_OUT:
			handle_zooming_out(delta)
		PlayerManager.PlayerState.FOCUS:
			handle_focus(delta)
	#print(current_speed)


# ----- INPUT & MOVEMENT -----

func handle_free_movement(delta: float) -> void:
	var movement_vector: Vector2 = get_movement_input()
	target_speed = default_speed
	reset_mouse_to_center()
	move_player(delta, movement_vector)

func handle_zooming_in(delta: float) -> void:
	var movement_vector: Vector2 = (target_position - global_position).normalized()
	if global_position.distance_to(target_position) >= 5.0:
		target_speed = focus_speed
		move_player(delta, movement_vector)
	else:
		current_speed = 0.0
		player_manager.set_player_to_focus()

func handle_zooming_out(delta: float) -> void:
	var movement_vector: Vector2 = get_movement_input()
	current_speed = exit_speed
	target_speed = default_speed
	reset_mouse_to_center()
	move_player(delta, movement_vector)

func handle_focus(_delta: float) -> void:
	target_speed = 0.0

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
