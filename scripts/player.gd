extends CharacterBody2D

@onready var phone: Area2D = $"../Phone"
@onready var asuka: Area2D = $"../Asuka"

@export var default_speed: float = 65.0  # Normal mouse sensitivity
@export var transition_speed: float = 5.0  # Speed of sensitivity transition
@export var towards_phone_speed: float = 800.0  # Speed of movement towards the phone

var current_speed: float
var target_speed: float
var movement_vector: Vector2
var phone_position: Vector2
var mouse_movement: Vector2

var viewport_size: Vector2
var center_position: Vector2

func _ready() -> void:
	viewport_size = get_viewport().get_visible_rect().size
	center_position = viewport_size / 2
	reset_mouse_to_center()
	phone_position = phone.global_position
	current_speed = default_speed

func _process(delta: float) -> void:
	mouse_movement = get_viewport().get_mouse_position() - center_position
	
	if phone.is_zooming_in:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		movement_vector = (phone_position - global_position).normalized()
		if global_position.distance_to(phone_position) < 5.0:  # Threshold for snapping to phone
			target_speed = 0
		else:
			target_speed = towards_phone_speed
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		movement_vector = mouse_movement
		target_speed = default_speed
		reset_mouse_to_center()
	
	current_speed = lerp(current_speed, target_speed, delta * transition_speed)
	velocity = movement_vector * current_speed
	move_and_slide()

func reset_mouse_to_center() -> void:
	Input.warp_mouse(center_position)
