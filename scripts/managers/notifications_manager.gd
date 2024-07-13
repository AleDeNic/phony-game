extends Node2D

@onready var phone_vibration: AudioStreamPlayer2D = get_node("/root/World/AudioManager/SFX/PhoneVibration")
@onready var phone_os: Control = get_node("/root/World/PhoneCanvas/Phone/PhoneOS")

signal notification

var rng = RandomNumberGenerator.new()
var probability: float = 0.1
var probability_increase: float = 0.1

var are_notifications_cleared: bool = true

var dialogue_state: int = 1


# ----- INIT -----

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if !PlayerManager.is_player_focused_phone():
		handle_notifications()


# ----- RANDOM NOTIFICATIONS -----

func handle_notifications() -> void:
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
