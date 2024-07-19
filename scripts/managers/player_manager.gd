extends Node

enum State {
	FREE,
	FOCUSING_ON_PHONE,
	FOCUSING_ON_ASUKA,
	FOCUSING_OUT,
	FOCUSED_PHONE,
	FOCUSED_ASUKA,
	DIALOGUE_PAUSED
}
@export var effects_increase_speed: float = 1.0

@onready var _current_state: State = State.FREE

var _player: CharacterBody2D       = null


# ----- INITIALIZATION AND PHYSICS -----

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_player = get_tree().get_first_node_in_group("player")
	if _player == null:
		push_warning("Player node not found!")


# ----- STATE SETTERS -----

func set_state(new_state: State) -> void:
	_current_state = new_state
	print("Player -> ", get_state_value())


func set_free() -> void:
	set_state(State.FREE)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func set_focusing_on_phone() -> void:
	set_state(State.FOCUSING_ON_PHONE)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func set_focusing_on_asuka() -> void:
	set_state(State.FOCUSING_ON_ASUKA)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func set_unfocus() -> void:
	set_state(State.FOCUSING_OUT)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func set_focus_on_phone() -> void:
	set_state(State.FOCUSED_PHONE)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func set_focus_on_asuka() -> void:
	set_state(State.FOCUSED_ASUKA)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func set_on_pause() -> void:
	set_state(State.DIALOGUE_PAUSED)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func set_unfocusing() -> void:
	set_state(State.FOCUSING_OUT)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


# ----- STATE -----
func get_player() -> CharacterBody2D:
	return _player


func get_state() -> State:
	return _current_state


func get_state_value() -> String:
	match _current_state:
		State.FREE:
			return "FREE"
		State.FOCUSING_ON_PHONE:
			return "FOCUSING_ON_PHONE"
		State.FOCUSING_ON_ASUKA:
			return "FOCUSING_ON_ASUKA"
		State.FOCUSING_OUT:
			return "FOCUSING_OUT"
		State.FOCUSED_PHONE:
			return "FOCUSED_PHONE"
		State.FOCUSED_ASUKA:
			return "FOCUSED_ASUKA"
		State.DIALOGUE_PAUSED:
			return "DIALOGUE_PAUSED"
		_:
			return "UNKNOWN"


func is_free() -> bool:
	return _current_state == State.FREE


func is_focusing_on_phone() -> bool:
	return _current_state == State.FOCUSING_ON_PHONE


func is_focusing_on_asuka() -> bool:
	return _current_state == State.FOCUSING_ON_ASUKA


func is_unfocusing() -> bool:
	return _current_state == State.FOCUSING_OUT


func is_focusing() -> bool:
	return _current_state in [State.FOCUSING_ON_PHONE, State.FOCUSING_ON_ASUKA, State.FOCUSING_OUT]


func is_focused_on_phone() -> bool:
	return _current_state == State.FOCUSED_PHONE


func is_focused_on_asuka() -> bool:
	return _current_state == State.FOCUSED_ASUKA


func is_dialogue_paused() -> bool:
	return _current_state == State.DIALOGUE_PAUSED
