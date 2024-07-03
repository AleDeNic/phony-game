extends Sprite2D

@onready var player: CharacterBody2D = get_node("/root/World/Player")

@export var min_player_x: float = 0.0
@export var max_player_x: float = 2400.0
@export var min_value_y_rot: float = -75.0
@export var max_value_y_rot: float = 0.0

@export var min_player_y: float = -1400.0
@export var max_player_y: float = 1400.0
@export var min_value_x_rot: float = -20.0
@export var max_value_x_rot: float = 20.0

@export var lerp_speed: float = 10.0

var current_y_rot: float = min_value_y_rot
var current_x_rot: float = min_value_x_rot

func map_range(value: float, from_min: float, from_max: float, to_min: float, to_max: float) -> float:
	return (value - from_min) / (from_max - from_min) * (to_max - to_min) + to_min

func _process(delta: float) -> void:
	var target_y_rot = map_range(player.global_position.x, min_player_x, max_player_x, min_value_y_rot, max_value_y_rot)
	current_y_rot = lerp(current_y_rot, target_y_rot, delta * lerp_speed)
	
	var target_x_rot = map_range(player.global_position.y, min_player_y, max_player_y, max_value_x_rot, min_value_x_rot)
	current_x_rot = lerp(current_x_rot, target_x_rot, delta * lerp_speed)

	material.set_shader_parameter("y_rot", current_y_rot)
	material.set_shader_parameter("x_rot", current_x_rot)
