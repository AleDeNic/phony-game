extends CharacterBody2D

@onready var game_manager: Node2D = %GameManager
@onready var phone: Area2D = $"../Phone"
@onready var asuka: Area2D = $"../Asuka"
@onready var window: Area2D = $"../Window"

@export var move_speed: float = 800.0  # Speed of the player when moving towards a target
@export var reset_speed: float = 2500.0
@export var mouse_sensitivity: float = 35.0  # Adjust this to change how much camera moves with mouse
@export var mouse_phone_sensitivity: float = 0.7
var last_mouse_pos: Vector2

func _ready() -> void:
	# Initialize last mouse position
	position = phone.position
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	reset_mouse_to_center()
	last_mouse_pos = get_viewport().get_mouse_position()

func _process(_delta: float) -> void:
	handle_mouse_movement()
	reset_to_phone(phone.position)

func handle_mouse_movement() -> void:
	var current_mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var center_position: Vector2 = viewport_size / 2
	var mouse_movement: Vector2 = current_mouse_pos - center_position
	calculate_velocity(mouse_movement)
	move_and_slide()

func calculate_velocity(mouse_movement) -> void:
	if phone.is_zooming_in == false:
		velocity = mouse_movement * mouse_sensitivity
		reset_mouse_to_center()
	else:
		velocity = mouse_movement * mouse_phone_sensitivity

func reset_mouse_to_center():
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var center_position: Vector2 = viewport_size / 2
	Input.warp_mouse(center_position)

func reset_to_phone(phone_position: Vector2):
	if game_manager.attention_span < 0:
		var direction: Vector2 = (phone_position - position).normalized()
		velocity = direction * reset_speed * get_physics_process_delta_time()
		move_and_collide(velocity)

		if position.distance_to(phone_position) < 1.0:
			velocity = Vector2.ZERO
