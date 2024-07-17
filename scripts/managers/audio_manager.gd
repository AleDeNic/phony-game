extends Node

@onready var player: CharacterBody2D = get_node("/root/World/Player")
@onready var asuka: Area2D = get_node("/root/World/Asuka")
@onready var window: Area2D = get_node("/root/World/Window")

@export var master_volume: float = -10.0
@export var music_volume: float = -0.1
@export var sfx_volume: float = -0.1
@export_group("Max volumes")
@export var asuka_max_volume: float = -15
@export var window_max_volume: float = -6
@export_group("Min volumes")
@export var asuka_min_volume: float = -40
@export var window_min_volume: float = -20
@export_group("Areas")
@export var asuka_area: float = 200
@export var window_area: float = 500
@export var max_distance: float = 1200.0

var music_layers: Array[AudioStreamPlayer] = []
var effects: Array[AudioStreamPlayer]      = []

var layer_paths: Array[String] = [
								 "res://assets/music/layer_0.mp3",
								 "res://assets/music/layer_1.mp3",
								 "res://assets/music/layer_2.mp3",
								 "res://assets/music/layer_3.mp3",
								 "res://assets/music/layer_4.mp3",
								 "res://assets/music/layer_5.mp3",
								 "res://assets/music/layer_6.mp3"
								 ]

var sfx_paths: Array[String]  = ["res://assets/sfx/phone_vibration.mp3"]
var active_layers: Array[int] = []
var bus_indices: Dictionary   = {}


func _ready() -> void:
	initialize_bus_indices()
	create_music_layers()
	apply_custom_volumes()
	add_music_layer(0)


func _physics_process(_delta: float) -> void:
	if player != null and asuka != null and window != null:
		AudioServer.set_bus_volume_db(bus_indices["Asuka"], calculate_volume(asuka, asuka_max_volume, asuka_min_volume, asuka_area))
		AudioServer.set_bus_volume_db(bus_indices["Window"], calculate_volume(window, window_max_volume, window_min_volume, window_area))


func initialize_bus_indices() -> void:
	var bus_names: Array[Variant] = ["Master", "Music", "SFX", "Asuka", "Window"]
	for bus_name in bus_names:
		bus_indices[bus_name] = AudioServer.get_bus_index(bus_name)


func create_music_layers() -> void:
	for i in range(layer_paths.size()):
		var audio_player = AudioStreamPlayer.new()
		audio_player.stream = load(layer_paths[i])
		audio_player.bus = "Music"
		add_child(audio_player)
		music_layers.append(audio_player)


func apply_custom_volumes() -> void:
	AudioServer.set_bus_volume_db(bus_indices["Master"], master_volume)
	AudioServer.set_bus_volume_db(bus_indices["Music"], music_volume)
	AudioServer.set_bus_volume_db(bus_indices["SFX"], sfx_volume)


func calculate_volume(object: Area2D, max_volume: float, min_volume: float, area: float) -> float:
	var transition_distance: float         = area
	var squared_distance: float            = player.position.distance_squared_to(object.position)
	var max_distance_squared: float        = max_distance * max_distance
	var transition_distance_squared: float = transition_distance * transition_distance
	var dB_value: float                    = max_volume

	if squared_distance > transition_distance_squared:
		dB_value = lerp(max_volume, min_volume, (squared_distance - transition_distance_squared) / (max_distance_squared - transition_distance_squared))
	else:
		dB_value = max_volume

	return dB_value


# ---- MUSIC ----
func add_music_layer(layer_index: int) -> void:
	if layer_index >= 0 and layer_index < music_layers.size():
		if layer_index not in active_layers:
					active_layers.append(layer_index)
	music_layers[layer_index].play()




func remove_music_layer(layer_index: int) -> void:
	if layer_index in active_layers:
		active_layers.erase(layer_index)
		music_layers[layer_index].stop()


func play_active_layers() -> void:
	for layer_index in active_layers:
		music_layers[layer_index].play()


func stop_active_layers() -> void:
	for layer_index in active_layers:
		music_layers[layer_index].stop()


func play_music_layer(layer_index: int) -> void:
	if layer_index >= 0 and layer_index < music_layers.size():
		music_layers[layer_index].play()


func stop_music_layer(layer_index: int) -> void:
	if layer_index >= 0 and layer_index < music_layers.size():
		music_layers[layer_index].stop()


func set_music_layer_volume(layer_index: int, volume_db: float) -> void:
	if layer_index >= 0 and layer_index < music_layers.size():
		music_layers[layer_index].volume_db = volume_db


func play_all_music_layers() -> void:
	for layer in music_layers:
		layer.play()


func stop_all_music_layers() -> void:
	for layer in music_layers:
		layer.stop()


# ---- SFX ----
func play_vibration() -> void:
	var vibration: AudioStreamPlayer = AudioStreamPlayer.new()
	vibration.stream = load(sfx_paths[0])
	vibration.bus = "SFX"
	add_child(vibration)
	vibration.play()
	effects.append(vibration)
