extends CharacterBody2D

@onready var game_manager: Node2D = %GameManager
@onready var phone: Area2D = $"../Phone"
@onready var asuka: Area2D = $"../Asuka"
@onready var window: Area2D = $"../Window"

@export var reset_speed: float = 2500.0
@export var mouse_sensitivity: float = 45.0  # Normal sensitivity
@export var mouse_phone_sensitivity: float = 0.7  # Sensitivity when zoomed in
@export var transition_speed: float = 5.0  # Speed of the sensitivity transition

var last_mouse_pos: Vector2
var current_sensitivity: float  # Current sensitivity being used
var target_sensitivity: float  # Target sensitivity to transition to

func _ready() -> void:
	# Initialize last mouse position
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	reset_mouse_to_center()
	last_mouse_pos = get_viewport().get_mouse_position()
	
	# Initialize sensitivities
	current_sensitivity = mouse_sensitivity
	target_sensitivity = mouse_sensitivity

func _process(_delta: float) -> void:
	handle_mouse_movement(_delta)
	#reset_to_phone(phone.position)

func handle_mouse_movement(delta: float) -> void:
	# Update current sensitivity towards the target sensitivity
	current_sensitivity = lerp(current_sensitivity, target_sensitivity, delta * transition_speed)
	
	var current_mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var center_position: Vector2 = viewport_size / 2
	var mouse_movement: Vector2 = current_mouse_pos - center_position
	
	calculate_velocity(mouse_movement)
	move_and_slide()

func calculate_velocity(mouse_movement: Vector2) -> void:
	if phone.is_zooming_in:
		transition_speed = 50
		target_sensitivity = mouse_phone_sensitivity
	else:
		transition_speed = 5
		target_sensitivity = mouse_sensitivity
		reset_mouse_to_center()

	velocity = mouse_movement * current_sensitivity

func reset_mouse_to_center():
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var center_position: Vector2 = viewport_size / 2
	Input.warp_mouse(center_position)

#func reset_to_phone(phone_position: Vector2):
	#if game_manager.attention_span < 0:
		#var direction: Vector2 = (phone_position - position).normalized()
		#velocity = direction * reset_speed * get_physics_process_delta_time()
		#move_and_collide(velocity)
#
		#if position.distance_to(phone_position) < 1.0:
			#velocity = Vector2.ZERO
