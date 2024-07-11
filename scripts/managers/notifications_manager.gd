extends Node2D

@onready var phone_vibration: AudioStreamPlayer2D = get_node("/root/World/AudioManager/SFX/PhoneVibration")
@onready var phone_os: Control = get_node("/root/World/Phone/PhoneOS")

var rng = RandomNumberGenerator.new()
var probability: float = 0.01
var probability_increase: float = 0.0003

var has_notification_arrived: bool = false

# ----- INIT -----

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if PlayerManager.is_player_focused_phone() == false and has_notification_arrived == false:
		increase_probability()
		handle_notifications()
	if PlayerManager.is_player_focused_phone() and has_notification_arrived == true:
		reset_notification()


# ----- RANDOM NOTIFICATIONS -----

func handle_notifications() -> void:
	var random_number: float = rng.randf_range(0.0, 100.0)
	if random_number <= probability:
		phone_vibration.play()
		probability = 0.001
		has_notification_arrived = true
		print("Notification arrived: ", random_number)

func increase_probability() -> void:
	probability += probability_increase
	#print(probability)

func reset_notification() -> void:
	has_notification_arrived = false
	print("notification reset")
