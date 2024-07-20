extends Node2D

# Parameters for the swing effect
@export var max_swing_offset: float = 40.0
@export var swing_speed: float = 0.5
@export var change_direction_interval: float = 0.5

# Original position to reset after swinging
var original_position: Vector2
# Current swing offsets
var current_swing_offset: Vector2
var target_swing_offset: Vector2
var change_direction_timer: float = 0.0


func _ready() -> void:
	original_position = position
	# Initialize swing offsets
	current_swing_offset = Vector2.ZERO
	target_swing_offset = Vector2.ZERO
	# Start the swing effect
	set_process(true)


func _physics_process(delta) -> void:
	# Update timer for changing direction
	change_direction_timer += delta

	# Change target swing offset direction at intervals
	if change_direction_timer >= change_direction_interval:
		change_direction_timer = 0.0
		target_swing_offset = Vector2(rand_range(-max_swing_offset, max_swing_offset),
		rand_range(-max_swing_offset, max_swing_offset))

	# Calculate the interpolation factor
	var lerp_factor: float = 1.0 - exp(-swing_speed * delta)

	# Smoothly interpolate towards the target swing offset
	current_swing_offset = current_swing_offset.lerp(target_swing_offset, lerp_factor)

	# Apply the swing offsets to the sprite's position
	position = original_position + current_swing_offset


# Function to generate random float between min and max
func rand_range(min_value, max_value) -> float:
	return randf() * (max_value - min_value) + min_value
