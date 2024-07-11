extends Node2D

@onready var phone_vibration: AudioStreamPlayer2D = get_node("/root/World/AudioManager/SFX/PhoneVibration")

var rng = RandomNumberGenerator.new()
var probability: float = 0.01

var has_notification_arrived: bool

# ----- INIT -----

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if BrainManager.player_panic >= BrainManager.panic_wait:
		increase_probability()
		handle_notifications()


# ----- RANDOM NOTIFICATIONS -----

func handle_notifications() -> void:
	if has_notification_arrived == false:
		var random_number: float = rng.randf_range(0.0, 100.0)
		if random_number <= probability:
			print("bingo", random_number)
			has_notification_arrived = true
			phone_vibration.play()
		#else:
			#print("noooooooooooo")

func increase_probability() -> void:
	if has_notification_arrived == false:
		probability += 0.0001
		print(probability)
