extends Node

@onready var player: CharacterBody2D = get_node("/root/World/Player")
@onready var asuka: Area2D = get_node("/root/World/Asuka")
@onready var window: Area2D = get_node("/root/World/Window")

var asuka_bus_index: int
var window_bus_index: int

@export_group("Max volumes")
@export var asuka_max_volume: float = -15
@export var window_max_volume: float = -6
@export_group("Min volumes")
@export var asuka_min_volume: float = -40
@export var window_min_volume: float = -20
@export_group("Areas")
@export var asuka_area: float = 200
@export var window_area: float = 500

func _ready() -> void:
	asuka_bus_index = AudioServer.get_bus_index("Asuka")
	window_bus_index = AudioServer.get_bus_index("Window")

func _process(_delta: float) -> void:
	AudioServer.set_bus_volume_db(asuka_bus_index, calculate_volume(asuka, asuka_max_volume, asuka_min_volume, asuka_area))
	AudioServer.set_bus_volume_db(window_bus_index, calculate_volume(window, window_max_volume, window_min_volume, window_area))

func calculate_volume(object: Area2D, max_volume: float, min_volume: float, area) -> float:
	var max_distance: float = 1200.0  # Adjust this value based on your game
	var transition_distance: float = area  # Adjust this value based on when you want the volume to start reaching 0 dB

	# Calculate the squared distance between the player and the object
	var squared_distance: float = player.position.distance_squared_to(object.position)

	# Calculate the maximum distance squared
	var max_distance_squared: float = max_distance * max_distance
	
	# Calculate the transition distance squared
	var transition_distance_squared: float = transition_distance * transition_distance

	# Map the squared distance to a volume range from 0 dB to -80 dB
	var dB_value: float = max_volume

	if squared_distance > transition_distance_squared:
		dB_value = lerp(max_volume, min_volume, (squared_distance - transition_distance_squared) / (max_distance_squared - transition_distance_squared))
	else:
		dB_value = max_volume

	return dB_value
