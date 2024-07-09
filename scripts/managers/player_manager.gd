extends Node

enum PlayerState { FREE, FOCUSING_IN, FOCUSING_OUT, FOCUSED }

@export var max_battery: float = 100.0
@export var max_stress: float = 100.0
@export var phone_stress_heal: float = 1.0
@export var asuka_stress_increase: float = 2.0
@export var window_stress_increase: float = 1.5
@export var effects_increase_speed: float = 1.0

@onready var player_state: PlayerState = PlayerState.FREE

# ----- INITIALIZATION AND PHYSICS -----
# ...

# ----- STATE SETTERS -----

func set_player_state(new_state: PlayerState) -> void:
	player_state = new_state
	print("Player -> ", get_player_state_value())

func set_player_free() -> void:
	set_player_state(PlayerState.FREE)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func set_player_focusing_in() -> void:
	set_player_state(PlayerState.FOCUSING_IN)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func set_player_focusing_out() -> void:
	set_player_state(PlayerState.FOCUSING_OUT)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func set_player_focused() -> void:
	set_player_state(PlayerState.FOCUSED)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# ----- STATE GETTERS -----

func get_player_state() -> PlayerState:
	return player_state

func get_player_state_value():
	match player_state:
		PlayerState.FREE:
			return "FREE"
		PlayerState.FOCUSING_IN:
			return "FOCUSING_IN"
		PlayerState.FOCUSING_OUT:
			return "FOCUSING_OUT"
		PlayerState.FOCUSED:
			return "FOCUSED"

func is_player_free() -> bool:
	return player_state == PlayerState.FREE

func is_player_focusing_in() -> bool:
	return player_state == PlayerState.FOCUSING_IN

func is_player_focusing_out() -> bool:
	return player_state == PlayerState.FOCUSING_OUT

func is_player_focusing() -> bool:
	return player_state in [PlayerState.FOCUSING_IN, PlayerState.FOCUSING_OUT]

func is_player_focused() -> bool:
	return player_state == PlayerState.FOCUSED
