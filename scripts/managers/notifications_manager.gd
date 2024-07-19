extends Node2D

@onready var phone_os: Control = get_node("/root/World/PhoneCanvas/ParallaxLayer/Phone/PhoneOS")
@onready var player: CharacterBody2D = get_node("/root/World/Player")

signal notification


# ----- PHONE SICKNESS -----

var phone_sickness_increase: int = 5
var phone_sickness_decrease: int = 20
var min_phone_sickness: int = 0
var max_phone_sickness: int = 100
#var phone_sickness_wait: int = 0
var phone_sickness: int = 0


# ----- NOTIFICATIONS -----

var notification_probability: float = 5.0
var asuka_message_probability: float = 40.0
var notification_probability_increase: float = 2.0
var are_notifications_cleared: bool = true
@onready var can_notifications_arrive: bool = true
var notification_cooldown: int = 20
var dialogue_state: int = 1


# ----- INIT AND PROCESS-----

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	notifications_coroutine()
	sickness_coroutine()

func notifications_coroutine() -> void:
	while true:
		await get_tree().create_timer(0.5).timeout
		handle_notifications()

func sickness_coroutine() -> void:
	while true:
		await get_tree().create_timer(0.1).timeout
		handle_phone_sickness()

func start_notification_cooldown() -> void:
	await get_tree().create_timer(notification_cooldown).timeout
	can_notifications_arrive = true

# ----- PHONE SICKNESS -----

func handle_phone_sickness() -> void:
	if Player.is_focused_on_phone() or Player.is_focusing_on_phone():
		reset_phone_sickness()
	elif are_notifications_cleared == false:
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
	if !Player.is_focused_on_phone() and !Player.is_focused_on_asuka() and can_notifications_arrive:
		var random_number: float = randf_range(0.0, 100.0)
		if random_number <= notification_probability:
			Audio.play_vibration()
			are_notifications_cleared = false
			can_notifications_arrive = false
			player.control.show()
			start_notification_cooldown()
			emit_signal("notification")

func increase_probability() -> void:
	notification_probability += dialogue_state * notification_probability_increase
	print("Probability increased by: ", dialogue_state * notification_probability_increase)

func clear_notifications() -> void:
	are_notifications_cleared = true
	player.control.hide()

func is_message_from_asuka() -> bool:
	var random_number: int = randi() % 100
	return random_number <= asuka_message_probability

func set_can_notifications_arrive(value: bool) -> void:
	can_notifications_arrive = value

func get_can_notifications_arrive() -> bool:
	return can_notifications_arrive
