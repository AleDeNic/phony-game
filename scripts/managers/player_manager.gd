extends Node

enum PlayerState {
	FREE,
	FOCUSING_ON_PHONE,
	FOCUSING_ON_ASUKA,
	FOCUSING_OUT,
	FOCUSED_PHONE,
	FOCUSED_ASUKA,
	DIALOGUE_PAUSED
}
@export var effects_increase_speed: float = 1.0

@onready var _current_state: PlayerState = PlayerState.FREE
var _player: CharacterBody2D = null

# ----- INITIALIZATION AND PHYSICS -----

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_player = get_tree().get_first_node_in_group("player")
	if _player == null:
		push_warning("PlayerManager: Player node not found!")

# ----- STATE SETTERS -----

func set_player_state(new_state: PlayerState) -> void:
	_current_state = new_state
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

func set_player_dialogue_paused() -> void:
	set_player_state(PlayerState.DIALOGUE_PAUSED)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# ----- STATE GETTERS -----
func get_player() -> CharacterBody2D:
	return _player

func get_player_state() -> PlayerState:
	return _current_state

func get_player_state_value():
	match _current_state:
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
		PlayerState.DIALOGUE_PAUSED:
			return "DIALOGUE_PAUSED"

func is_player_free() -> bool:
	return _current_state == PlayerState.FREE

func is_player_focusing_on_phone() -> bool:
	return _current_state == PlayerState.FOCUSING_ON_PHONE

func is_player_focusing_on_asuka() -> bool:
	return _current_state == PlayerState.FOCUSING_ON_ASUKA

func is_player_focusing_out() -> bool:
	return _current_state == PlayerState.FOCUSING_OUT

func is_player_focusing() -> bool:
	return _current_state in [PlayerState.FOCUSING_ON_PHONE, PlayerState.FOCUSING_ON_ASUKA, PlayerState.FOCUSING_OUT]

func is_player_focused_phone() -> bool:
	return _current_state == PlayerState.FOCUSED_PHONE

func is_player_focused_asuka() -> bool:
	return _current_state == PlayerState.FOCUSED_ASUKA

func is_player_dialogue_paused() -> bool:
	return _current_state == PlayerState.DIALOGUE_PAUSED
