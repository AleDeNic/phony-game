extends Node2D

#region VARIABLES
const MAX_SWING_OFFSET: float = 40.0
const SWING_SPEED: float = 0.5
const CHANGE_DIRECTION_INTERVAL: float = 0.5

var original_position: Vector2
var current_swing_offset: Vector2
var target_swing_offset: Vector2
var change_direction_timer: float = 0.0
#endregion


func _ready() -> void:
	original_position = position
	# Initialize swing offsets
	current_swing_offset = Vector2.ZERO
	target_swing_offset = Vector2.ZERO
	# Start the swing effect
	set_process(true)


func _physics_process(delta) -> void:
	change_direction_timer += delta

	if change_direction_timer >= CHANGE_DIRECTION_INTERVAL:
		change_direction_timer = 0.0
		target_swing_offset = Vector2(random_range(-MAX_SWING_OFFSET, MAX_SWING_OFFSET),
		random_range(-MAX_SWING_OFFSET, MAX_SWING_OFFSET))

	var lerp_factor: float = 1.0 - exp(-SWING_SPEED * delta)

	current_swing_offset = current_swing_offset.lerp(target_swing_offset, lerp_factor)
	position = original_position + current_swing_offset


func random_range(min_value, max_value) -> float:
	return randf() * (max_value - min_value) + min_value
