class_name PlayerManager
extends Node

enum PlayerState { FREE, ZOOMING_IN, ZOOMING_OUT, FOCUS }

@export var max_battery: float = 100.0
@export var max_stress: float = 100.0
@export var phone_stress_heal: float = 1.0
@export var asuka_stress_increase: float = 2.0
@export var window_stress_increase: float = 1.5
@export var effects_increase_speed: float = 1.0

var player_state: PlayerState = PlayerState.FREE

@onready var player: CharacterBody2D = %Player
@onready var phone: Area2D = $"../Phone"
@onready var camera: Camera2D = $"../Player/Camera2D"


# ----- INITIALIZATION AND PHYSICS -----

func _ready() -> void:
	set_player_free()

func _physics_process(_delta: float) -> void:
	print_player_state(player_state)


# ----- GET STATE -----

func get_player_state() -> PlayerState:
	return player_state


# ----- SET GENERIC STATE -----

func set_player_state(new_state: PlayerState) -> void:
	player_state = new_state


# ----- SET SPECIFIC STATE -----

func set_player_free() -> void:
	set_player_state(PlayerState.FREE)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func set_player_zooming_in() -> void:
	set_player_state(PlayerState.ZOOMING_IN)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func set_player_zooming_out() -> void:
	set_player_state(PlayerState.ZOOMING_OUT)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func set_player_to_focus() -> void:
	set_player_state(PlayerState.FOCUS)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# ----- STATE BOOLEANS -----

func is_player_free() -> bool:
	return player_state == PlayerState.FREE

func is_player_zooming_in() -> bool:
	return player_state == PlayerState.ZOOMING_IN

func is_player_zooming_out() -> bool:
	return player_state == PlayerState.ZOOMING_OUT

func is_player_zooming() -> bool:
	return player_state in [PlayerState.ZOOMING_IN, PlayerState.ZOOMING_OUT]

func is_player_to_focus() -> bool:
	return player_state == PlayerState.FOCUS


# ----- DEBUG FUNCTIONS -----
func print_player_state(state):
	match state:
		PlayerState.FREE:
			print("Player state: FREE")
		PlayerState.ZOOMING_IN:
			print("Player state: ZOOMING_IN")
		PlayerState.ZOOMING_OUT:
			print("Player state: ZOOMING_OUT")
		PlayerState.FOCUS:
			print("Player state: FOCUS")
