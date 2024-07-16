extends Node

enum AsukaState {
	PLEASED,
	TALKING,
	UPSET
}

enum EyeState {
	NORMAL,
	CLOSED,
	LOOKAWAY
}
	
@onready var asuka_state: AsukaState = AsukaState.PLEASED
@onready var eye_state: EyeState = EyeState.NORMAL

# ----- STATE SETTERS -----
func set_asuka_state(new_state: AsukaState) -> void:
	asuka_state = new_state
	print("Asuka -> ", get_asuka_state_value())
	
func set_asuka_pleased() -> void:
		set_asuka_state(AsukaState.PLEASED)
	
func set_asuka_talking() -> void:
		set_asuka_state(AsukaState.TALKING)
	
func set_asuka_upset() -> void:
		set_asuka_state(AsukaState.UPSET)
	
# ----- ASUKA STATE GETTERS -----
func get_asuka_state() -> AsukaState:
	return asuka_state
	
func get_asuka_state_value():
	match asuka_state:
		AsukaState.PLEASED:
			return "PLEASED"
		AsukaState.TALKING:
			return "TALKING"
		AsukaState.UPSET:
			return "UPSET"
			
func is_asuka_pleased() -> bool:
		return asuka_state == AsukaState.PLEASED
	
func is_asuka_talking() -> bool:
		return asuka_state == AsukaState.TALKING
	
func is_asuka_upset() -> bool:
		return asuka_state == AsukaState.UPSET
	
# ----- EYE STATE SETTERS -----

func set_eye_state(new_state: EyeState) -> void:
	eye_state = new_state
	
func set_eye_normal() -> void:
	set_eye_state(EyeState.NORMAL)
	
func set_eye_closed() -> void:
	set_eye_state(EyeState.CLOSED)
	
func set_eye_lookaway() -> void:
	set_eye_state(EyeState.LOOKAWAY)
	
# ----- EYE STATE GETTERS -----
func get_eye_state() -> EyeState:
	return eye_state
	
func get_eye_state_value():
	match eye_state:
		EyeState.NORMAL:
			return "NORMAL"
		EyeState.CLOSED:
			return "CLOSED"
		EyeState.LOOKAWAY:
			return "LOOKAWAY"

func is_eye_normal() -> bool:
	return eye_state == EyeState.NORMAL
	
func is_eye_closed() -> bool:
	return eye_state == EyeState.CLOSED
	
func is_eye_lookaway() -> bool:
	return eye_state == EyeState.LOOKAWAY

