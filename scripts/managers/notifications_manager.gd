extends Node2D

@onready var phone_vibration: AudioStreamPlayer2D = get_node("/root/World/AudioManager/SFX/PhoneVibration")
@onready var phone_os: Control = get_node("/root/World/PhoneCanvas/Phone/PhoneOS")

signal notification

# ----- PHONE SICKNESS -----

var phone_sickness_increase: int = 1
var phone_sickness_decrease: int = 30
var max_phone_sickness: int = 300
var phone_sickness_wait: int = 100
var phone_sickness: int = 0

# ----- NOTIFICATIONS -----

var rng = RandomNumberGenerator.new()
var probability: float = 0.6 # should be 0.1 in the final game
var probability_increase: float = 0.1
var are_notifications_cleared: bool = true

var dialogue_state: int = 1


# ----- INIT AND PROCESS-----

func _physics_process(_delta: float) -> void:
	handle_notifications()
	handle_phone_sickness()
	# print("Player phone_sickness: ", phone_sickness)


# ----- PHONE SICKNESS -----

func handle_phone_sickness() -> void:
	if NotificationsManager.are_notifications_cleared:
		reset_phone_sickness()
	else:
		increase_phone_sickness()

func increase_phone_sickness() -> void:
	if phone_sickness < max_phone_sickness:
		phone_sickness += phone_sickness_increase

func reset_phone_sickness() -> void:
	if phone_sickness > phone_sickness_decrease:
		phone_sickness -= phone_sickness_decrease
	else:
		phone_sickness = 0


# ----- RANDOM NOTIFICATIONS -----

func handle_notifications() -> void:
	if PlayerManager.is_player_focused_phone():
		reset_phone_sickness()
	else:
		var random_number: float = rng.randf_range(0.0, 100.0)
		if random_number <= probability:
			phone_vibration.play()
			are_notifications_cleared = false
			emit_signal("notification")
			print("notification arrived. Probability: ", probability)

func increase_probability() -> void:
	probability += dialogue_state * probability_increase
	print("Probability increased by: ", dialogue_state * probability_increase)

func clear_notifications() -> void:
	are_notifications_cleared = true
