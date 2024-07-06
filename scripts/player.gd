extends CharacterBody2D

@onready var phone: Area2D = $"../Phone"
@export var default_speed: float = 65.0
@export var transition_speed: float = 5.0
@export var towards_phone_speed: float = 400.0
@export var exit_speed: float = 30

var current_speed: float = default_speed
var target_speed: float
var state: String = "free"
var viewport: Viewport

func _ready() -> void:
	viewport = get_viewport()
	reset_mouse_to_center()

func _process(delta: float) -> void:
	handle_speeds(delta)
	move_and_slide()

func handle_speeds(delta: float) -> void:
	var movement_vector: Vector2
	
	if state in ["phone_zooming_in", "phone"]:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		movement_vector = (phone.global_position - global_position).normalized()
		if global_position.distance_to(phone.global_position) < 30.0:
			target_speed = 0.0
		else:
			target_speed = towards_phone_speed
	else:
		if state == "phone_zooming_out":
			current_speed = exit_speed
			target_speed = default_speed
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		var mouse_pos = viewport.get_mouse_position()
		var center = viewport.get_visible_rect().size / 2
		movement_vector = mouse_pos - center
		target_speed = default_speed
		reset_mouse_to_center()

	current_speed = lerp(current_speed, target_speed, delta * transition_speed)
	velocity = movement_vector * current_speed

func reset_mouse_to_center() -> void:
	viewport.warp_mouse(viewport.get_visible_rect().size / 2)
