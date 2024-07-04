extends Camera3D

@onready var player: CharacterBody2D = get_node("/root/World/Player")

# Exported values for mapping
@export var min_player_x: float = 2400.0
@export var max_player_x: float = 0.0
@export var min_rotation: float = 50.0  # Yaw in degrees
@export var max_rotation: float = 50.0  # Yaw in degrees
@export var lerp_speed: float = 2.0  # Speed of rotation smoothing

# Variables to store current rotation
var current_yaw: float = min_rotation
var target_yaw: float = min_rotation

func _process(delta: float) -> void:
	# Get the player's global x position
	var player_x_position = player.global_position.x
	
	# Map player_x_position to camera rotation (yaw)
	target_yaw = map_range(player_x_position, min_player_x, max_player_x, min_rotation, max_rotation)
	
	# Smoothly interpolate current yaw towards target yaw
	current_yaw = lerp_angle(current_yaw, target_yaw, lerp_speed * delta)
	
	# Apply the rotation to the Camera3D
	rotation_degrees.y = current_yaw
	
	print(rotation_degrees.y)

func map_range(value: float, from_min: float, from_max: float, to_min: float, to_max: float) -> float:
	return (value - from_min) / (from_max - from_min) * (to_max - to_min) + to_min

# Helper function to smoothly interpolate angles
func lerp_angle(from_angle: float, to_angle: float, weight: float) -> float:
	var difference = to_angle - from_angle
	
	# Adjust difference to be in the range [-180, 180]
	while difference > 180.0:
		difference -= 360.0
	while difference < -180.0:
		difference += 360.0
	
	return from_angle + difference * weight
