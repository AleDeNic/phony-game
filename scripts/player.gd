extends CharacterBody2D

enum State { FREE, ZOOMING_IN, ZOOMING_OUT, IN_DIALOGUE }

@export var default_speed: float = 65.0
@export var transition_speed: float = 5.0
@export var zoom_speed: float = 400.0
@export var exit_speed: float = 12.0
@export var dead_zone_radius: float = 1.0

@onready var game_manager: Node = $"../GameManager"

var current_speed: float = default_speed
var target_speed: float
var state: State = State.FREE
var viewport: Viewport
var target_position: Vector2
var last_movement: Vector2 = Vector2.ZERO
var stopping: bool = false

func _ready() -> void:
	viewport = get_viewport()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	reset_mouse_to_center()

func _physics_process(delta: float) -> void:
	if game_manager.player_state != game_manager.PlayerState.IN_DIALOGUE:
		transition_to_free()
		handle_movement(delta)
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func handle_movement(delta: float) -> void:
	var movement_vector: Vector2
	
	match state:
		State.ZOOMING_IN:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			movement_vector = (target_position - global_position).normalized()
			target_speed = zoom_speed if global_position.distance_to(target_position) >= 30.0 else 0.0
		State.ZOOMING_OUT:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			movement_vector = get_movement_input()
			current_speed = exit_speed
			target_speed = default_speed
			reset_mouse_to_center()
		State.FREE:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			movement_vector = get_movement_input()
			target_speed = default_speed
			reset_mouse_to_center()

	current_speed = lerp(current_speed, target_speed, delta * transition_speed)
	
	if movement_vector != Vector2.ZERO:
		last_movement = movement_vector
	elif last_movement != Vector2.ZERO:
		movement_vector = last_movement
		last_movement = last_movement.move_toward(Vector2.ZERO, delta * transition_speed)

	velocity = movement_vector * current_speed

func get_movement_input() -> Vector2:
	var mouse_pos = viewport.get_mouse_position()
	var center = viewport.get_visible_rect().size / 2
	var movement_vector = mouse_pos - center
	return Vector2.ZERO if movement_vector.length() < dead_zone_radius else movement_vector

func reset_mouse_to_center() -> void:
	viewport.warp_mouse(viewport.get_visible_rect().size / 2)

func start_zoom(position: Vector2) -> void:
	state = State.ZOOMING_IN
	game_manager.set_player_state(state)
	target_position = position
	last_movement = Vector2.ZERO

func end_zoom() -> void:
	state = State.ZOOMING_OUT
	game_manager.set_player_state(state)

func set_free() -> void:
	state = State.FREE
	game_manager.set_player_state(game_manager.PlayerState.FREE)
	reset_mouse_to_center()
	stopping = false
	last_movement = Vector2.ZERO

func set_dialogue() -> void:
	state = State.IN_DIALOGUE
	last_movement = Vector2.ZERO

func end_dialogue() -> void:
	state = State.ZOOMING_OUT
	game_manager.set_player_state(game_manager.PlayerState.ZOOMING_OUT)
	stopping = true
	reset_mouse_to_center()
	
func transition_to_free() -> void:
	if state == State.ZOOMING_OUT and current_speed < 60.0:
		set_free()
