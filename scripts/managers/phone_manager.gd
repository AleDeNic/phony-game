extends Node

enum PhoneState { OFF, APPS, SETTINGS, CAMERA, CHATS, ASUKACHAT, DISCHARGED }

@onready var phone_state: PhoneState = PhoneState.OFF

# ----- INITIALIZERS -----
# ...

# ----- STATE SETTERS -----

func set_phone_state(new_state: PhoneState) -> void:
	phone_state = new_state
	print("Phone -> ", get_phone_state_value())
	
func set_phone_off() -> void:
	set_phone_state(PhoneState.OFF)

func set_phone_in_apps() -> void:
	set_phone_state(PhoneState.APPS)
	
func set_phone_in_settings() -> void:
	set_phone_state(PhoneState.SETTINGS)
	
func set_phone_in_camera() -> void:
	set_phone_state(PhoneState.CAMERA)
	
func set_phone_in_chats() -> void:
	set_phone_state(PhoneState.CHATS)
	
func set_phone_in_asukachat() -> void:
	set_phone_state(PhoneState.ASUKACHAT)

func set_phone_discharged() -> void:
	set_phone_state(PhoneState.DISCHARGED)


# ----- STATE GETTERS -----

func get_phone_state() -> PhoneState:
	return phone_state

func get_phone_state_value():
	match phone_state:
		PhoneState.OFF:
			return "OFF"
		PhoneState.APPS:
			return "APPS"
		PhoneState.SETTINGS:
			return "SETTINGS"
		PhoneState.CAMERA:
			return "CAMERA"
		PhoneState.CHATS:
			return "CHATS"
		PhoneState.ASUKACHAT:
			return "ASUKA CHAT"
			
func is_phone_off() -> bool:
	return phone_state == PhoneState.OFF
	
func is_phone_in_apps() -> bool:
	return phone_state == PhoneState.APPS
	
func is_phone_in_settings() -> bool:
	return phone_state == PhoneState.SETTINGS
	
func is_phone_in_camera() -> bool:
	return phone_state == PhoneState.CAMERA
	
func is_phone_in_chats() -> bool:
	return phone_state == PhoneState.CHATS
	
func is_phone_in_asukachat() -> bool:
	return phone_state == PhoneState.ASUKACHAT
	
func is_battery_active() -> bool:
	return phone_state not in [PhoneState.OFF, PhoneState.SETTINGS]

func is_phone_discharged() -> bool:
	return phone_state == PhoneState.DISCHARGED
