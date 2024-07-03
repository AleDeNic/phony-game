extends Sprite2D

@onready var player: CharacterBody2D = get_node("/root/World/Player")

var y_perspective: float

@export var min_player_x: float = 0.0
@export var max_player_x: float = 2400.0
@export var min_value: float = -70.0
@export var max_value: float = 0.0

var player_x_position: float = 0.0  # Replace this with actual player position in your game
var mapped_value: float = 0.0       # This will store the result of the mapping

# Function to map a value from one range to another
func map_range(value: float, from_min: float, from_max: float, to_min: float, to_max: float) -> float:
	return (value - from_min) / (from_max - from_min) * (to_max - to_min) + to_min

# Function to update the mapped value based on the player's x position
func update_mapped_value() -> void:
	mapped_value = map_range(player.global_position.x, min_player_x, max_player_x, min_value, max_value)
	print("Mapped Value: ", mapped_value)  # This will print the mapped value for debugging
	material.set_shader_parameter("y_rot", mapped_value)

# Example _process function that updates the mapped value each frame
func _process(delta: float) -> void:
	update_mapped_value()

	
	
