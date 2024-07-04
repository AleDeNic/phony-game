extends CharacterBody2D

# ISSUE handle the player state with asuka

@onready var phone: Area2D = $"../Phone"
@onready var asuka: Area2D = $"../Asuka"
@onready var exit_trigger: StaticBody2D = $ExitTrigger

@export var default_speed: float = 65.0
@export var transition_speed: float = 5.0
@export var towards_phone_speed: float = 200.0
@export var exit_speed: float = 30

var current_speed: float
var target_speed: float
var movement_vector: Vector2
var phone_position: Vector2

var state: String

var viewport_size: Vector2
var center_position: Vector2
var object_position: Vector2

func _ready() -> void:
	viewport_size = get_viewport().get_visible_rect().size
	center_position = viewport_size / 2
	reset_mouse_to_center()
	phone_position = phone.global_position
	current_speed = default_speed
	state = "free"

func _process(delta: float) -> void:
	handle_speeds(delta)
	move_and_slide()
	#print(current_speed)
	#print(state)
	#print(global_position)

func handle_speeds(delta: float) -> void:
	if state in ["phone_zooming_in", "phone"]:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		movement_vector = (object_position - global_position).normalized()
		if global_position.distance_to(object_position) < 30.0:
			target_speed = 0.0
		else:
			target_speed = towards_phone_speed
	else:
		if state in ["phone_zooming_out"]:
			current_speed = 30.0
			target_speed = default_speed
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		movement_vector = get_viewport().get_mouse_position() - center_position
		target_speed = default_speed
		reset_mouse_to_center()
	current_speed = lerp(current_speed, target_speed, delta * transition_speed)
	velocity = movement_vector * current_speed

func reset_mouse_to_center() -> void:
	Input.warp_mouse(center_position)
