extends Node

enum State { OFF, APPS, SETTINGS, MUSIC, CAMERA, CHAT, DISCHARGED, COMINGSOON }

@onready var phone_state: State = State.OFF

# ----- INITIALIZERS -----
# ...

# ----- STATE SETTERS -----

func set_phone_state(new_state: State) -> void:
	phone_state = new_state
	print("Phone -> ", get_state_value())

func set_phone_off() -> void:
	set_phone_state(State.OFF)

func set_phone_in_apps() -> void:
	set_phone_state(State.APPS)

func set_phone_in_settings() -> void:
	set_phone_state(State.SETTINGS)

func set_phone_in_music() -> void:
	set_phone_state(State.MUSIC)

func set_phone_in_camera() -> void:
	set_phone_state(State.CAMERA)

func set_phone_in_chat() -> void:
	set_phone_state(State.CHAT)

func set_phone_discharged() -> void:
	set_phone_state(State.DISCHARGED)


# ----- STATE GETTERS -----

func get_state() -> State:
	return phone_state

func get_state_value() -> String:
	match phone_state:
		State.OFF:
			return "OFF"
		State.APPS:
			return "APPS"
		State.SETTINGS:
			return "SETTINGS"
		State.MUSIC:
			return "MUSIC"
		State.CAMERA:
			return "CAMERA"
		State.CHAT:
			return "CHAT"
		State.DISCHARGED:
			return "DISCHARGED"
		State.COMINGSOON:
			return "COMINGSOON"
		_:
			return "COMINGSOON"

func is_off() -> bool:
	return phone_state == State.OFF

func in_apps() -> bool:
	return phone_state == State.APPS

func in_settings() -> bool:
	return phone_state == State.SETTINGS

func in_music() -> bool:
	return phone_state == State.MUSIC

func in_camera() -> bool:
	return phone_state == State.CAMERA

func in_chat() -> bool:
	return phone_state == State.CHAT

func is_battery_active() -> bool:
	return phone_state not in [State.OFF, State.SETTINGS, State.DISCHARGED]

func is_discharged() -> bool:
	return phone_state == State.DISCHARGED

func reset_all() -> void:
	set_phone_off()
