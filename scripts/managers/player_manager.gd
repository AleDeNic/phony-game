extends Node

enum PlayerState { FREE, FOCUSING_ON_PHONE, FOCUSING_ON_ASUKA, FOCUSING_OUT, FOCUSED_PHONE, FOCUSED_ASUKA }

@export var max_battery: float = 100.0
@export var max_stress: float = 100.0
@export var effects_increase_speed: float = 1.0

@onready var player_state: PlayerState = PlayerState.FREE

# ----- INITIALIZATION AND PHYSICS -----
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# ----- STATE SETTERS -----

func set_player_state(new_state: PlayerState) -> void:
	player_state = new_state
	print("Player -> ", get_player_state_value())

func set_player_free() -> void:
	set_player_state(PlayerState.FREE)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func set_player_focusing_on_phone() -> void:
	set_player_state(PlayerState.FOCUSING_ON_PHONE)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func set_player_focusing_on_asuka() -> void:
	set_player_state(PlayerState.FOCUSING_ON_ASUKA)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func set_player_focusing_out() -> void:
	set_player_state(PlayerState.FOCUSING_OUT)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func set_player_focused_phone() -> void:
	set_player_state(PlayerState.FOCUSED_PHONE)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func set_player_focused_asuka() -> void:
	set_player_state(PlayerState.FOCUSED_ASUKA)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# ----- STATE GETTERS -----

func get_player_state() -> PlayerState:
	return player_state

func get_player_state_value():
	match player_state:
		PlayerState.FREE:
			return "FREE"
		PlayerState.FOCUSING_ON_PHONE:
			return "FOCUSING_ON_PHONE"
		PlayerState.FOCUSING_ON_ASUKA:
			return "FOCUSING_ON_ASUKA"
		PlayerState.FOCUSING_OUT:
			return "FOCUSING_OUT"
		PlayerState.FOCUSED_PHONE:
			return "FOCUSED_PHONE"
		PlayerState.FOCUSED_ASUKA:
			return "FOCUSED_ASUKA"

func is_player_free() -> bool:
	return player_state == PlayerState.FREE

func is_player_focusing_on_phone() -> bool:
	return player_state == PlayerState.FOCUSING_ON_PHONE

func is_player_focusing_on_asuka() -> bool:
	return player_state == PlayerState.FOCUSING_ON_ASUKA

func is_player_focusing_out() -> bool:
	return player_state == PlayerState.FOCUSING_OUT

func is_player_focusing() -> bool:
	return player_state in [PlayerState.FOCUSING_ON_PHONE, PlayerState.FOCUSING_ON_ASUKA, PlayerState.FOCUSING_OUT]

func is_player_focused_phone() -> bool:
	return player_state == PlayerState.FOCUSED_PHONE

func is_player_focused_asuka() -> bool:
	return player_state == PlayerState.FOCUSED_ASUKA
