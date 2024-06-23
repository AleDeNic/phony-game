extends CharacterBody2D

@onready var game_manager: Node2D = %GameManager
@onready var phone: Area2D = $"../Phone"
@onready var asuka: Area2D = $"../Asuka"
@onready var window: Area2D = $"../Window"

@export var move_speed: float = 800.0  # Speed of the player when moving towards a target
@export var mouse_sensitivity: float = 25  # Adjust this to change how much camera moves with mouse
var last_mouse_pos: Vector2

func _ready() -> void:
	# Initialize last mouse position
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	reset_mouse_to_center()
	last_mouse_pos = get_viewport().get_mouse_position()

func _process(_delta: float) -> void:
	# Get the current mouse position
	var current_mouse_pos: Vector2 = get_viewport().get_mouse_position()
	
	# Calculate the mouse movement relative to the center
	var viewport_size: Vector2   = get_viewport().get_visible_rect().size
	var center_position: Vector2 = viewport_size / 2
	var mouse_movement: Vector2  = current_mouse_pos - center_position
	
	reset_to_phone()
	
	# Reset the mouse to the center of the screen
	reset_mouse_to_center()
	
	# Calculate the new motion based on mouse movement
	var motion: Vector2 = mouse_movement * mouse_sensitivity
	velocity = motion
	move_and_slide()

# Function to reset the mouse cursor to the center of the screen
func reset_mouse_to_center():
	# Get the center of the viewport
	var viewport_size: Vector2   = get_viewport().get_visible_rect().size
	var center_position: Vector2 = viewport_size / 2
	
	# Set the mouse position to the center of the screen
	Input.warp_mouse(center_position)

func reset_to_phone() -> void:
	if game_manager.attention_span < 0:
		# TO CHANGE TO MOVE_AND_COLLIDE!!!
		position = phone.position
		#move_and_collide(velocity)
		return  # Early return to avoid further processing
