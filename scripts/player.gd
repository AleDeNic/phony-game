extends CharacterBody2D

@onready var game_manager: Node2D = %GameManager
@onready var phone: Area2D = $"../Phone"
@onready var asuka: Area2D = $"../Asuka"
@onready var window: Area2D = $"../Window"

@export var move_speed: float = 800.0  # Speed of the player when moving towards a target
@export var reset_speed: float = 2500.0
@export var mouse_sensitivity: float = 25  # Adjust this to change how much camera moves with mouse
var last_mouse_pos: Vector2

func _ready() -> void:
	# Initialize last mouse position
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
	reset_mouse_to_center()

	velocity = mouse_movement * mouse_sensitivity
	move_and_slide()

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
