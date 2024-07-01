extends CharacterBody2D

@onready var phone: Area2D = $"../Phone"
@onready var asuka: Area2D = $"../Asuka"
@onready var trigger_collision: Area2D = $Trigger

@export var mouse_sensitivity: float = 65.0  # Normal mouse sensitivity
@export var mouse_phone_sensitivity: float = 0.7  # Sensitivity when zoomed in
@export var transition_speed: float = 5.0  # Speed of sensitivity transition
@export var move_speed: float = 800.0  # Speed of movement towards the phone

var last_mouse_pos: Vector2  # Last recorded mouse position
var current_sensitivity: float  # Current mouse sensitivity
var target_sensitivity: float  # Target sensitivity to transition to
var is_locked: bool = false  # Whether player is locked to phone position

func _ready() -> void:
	# Initialize mouse mode and position
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	reset_mouse_to_center()
	last_mouse_pos = get_viewport().get_mouse_position()
	
	# Initialize sensitivities
	current_sensitivity = mouse_sensitivity
	target_sensitivity = mouse_sensitivity

func _process(_delta: float) -> void:
	handle_mouse_movement(_delta)

func handle_mouse_movement(delta: float) -> void:
	# Smoothly transition to target sensitivity
	current_sensitivity = lerp(current_sensitivity, target_sensitivity, delta * transition_speed)
	
	var current_mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var center_position: Vector2 = viewport_size / 2
	var mouse_movement: Vector2 = current_mouse_pos - center_position
	
	# Move towards phone if zooming in
	if phone.is_zooming_in and not is_locked:
		move_towards_phone()
	# Lock position if reached phone
	elif is_locked:
		global_position = phone.global_position  # Snap player to phone
		velocity = Vector2.ZERO  # Stop movement
	else:
		# Normal movement
		transition_speed = 5
		target_sensitivity = mouse_sensitivity
		calculate_velocity(mouse_movement)
		reset_mouse_to_center()
		move_and_slide()

func calculate_velocity(mouse_movement: Vector2) -> void:
	# Calculate movement velocity based on mouse movement and sensitivity
	velocity = mouse_movement * current_sensitivity

func move_towards_phone() -> void:
	# Move player towards phone's position
	var phone_position: Vector2 = phone.global_position
	var direction: Vector2 = (phone_position - global_position).normalized()
	
	# Set velocity in the direction of the phone
	velocity = direction * move_speed
	move_and_slide()  # Move the player

	print("Moving towards phone... Distance: ", global_position.distance_to(phone_position))

	# Check if close enough to phone to stop movement
	if global_position.distance_to(phone_position) < 5.0:  # Threshold for snapping to phone
		is_locked = true
		velocity = Vector2.ZERO
		print("Locked to phone position")

func reset_mouse_to_center() -> void:
	# Warp the mouse cursor to the center of the viewport
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var center_position: Vector2 = viewport_size / 2
	Input.warp_mouse(center_position)
