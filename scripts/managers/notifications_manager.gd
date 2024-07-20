extends Node2D

@onready var phone_os: Control = get_node("/root/World/PhoneCanvas/ParallaxLayer/Phone/PhoneOS")
@onready var player: CharacterBody2D = get_node("/root/World/Player")

signal notification

#region variables
#region variables.sickness
var notification_weight: int = 15
var max_phone_sickness: int = 100
var min_phone_sickness: int = 0
var phone_sickness: int = 0
var phone_sickness_decrease: int = 20
#endregion

#region variables.notifications
var inbox_state: Inbox   = Inbox.CLEARED
var notification_state: Notification = Notification.CAN_ARRIVE

enum Inbox {
	DIRTY,
	CLEARED,
}

enum Notification {
	CAN_ARRIVE,
	CANNOT_ARRIVE,
}

var notifications_amount: int = 0
var notification_cooldown: int = 20
var dialogue_state: int = 1

var probability: float                   = 50.0
var probability_of_asuka_messages: float = 40.0
var probability_increment: float         = 2.0
#endregion
#endregion

# ----- INIT AND PROCESS-----

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	notifications_coroutine()
	sickness_coroutine()

func sickness_coroutine() -> void:
	while true:
		await get_tree().create_timer(1).timeout
		handle_phone_sickness()

func handle_phone_sickness() -> void:
	if Player.is_focused_on_phone() or Player.is_focusing_on_phone():
		reset_phone_sickness()
	elif in_inbox_dirty():
		update_phone_sickness()

func update_phone_sickness() -> void:
	phone_sickness = calculate_sickness()

func calculate_sickness() -> int:
	var sickness = notifications_amount * notification_weight
	return min(sickness, max_phone_sickness)

func reset_phone_sickness() -> void:
	phone_sickness = max(phone_sickness - phone_sickness_decrease, 0)
#endregion

#region Notifications
func handle_notifications() -> void:
	if !Player.is_focused_on_phone() and !Player.is_focused_on_asuka() and can_arrive():
		var random_number: float = randf_range(0.0, 100.0)
		if random_number <= probability:
			Player.set_drifting_to_phone()
			Audio.play_vibration()
			increase_amount()
			set_inbox_incoming()
			set_cannot_arrive()

			player.control.show()
			start_notification_cooldown()
			emit_signal("notification")

func increase_probability() -> void:
	probability += dialogue_state * probability_increment
	print("Probability increased by: ", dialogue_state * probability_increment)

func notifications_coroutine() -> void:
	while true:
		await get_tree().create_timer(0.5).timeout
		handle_notifications()

func start_notification_cooldown() -> void:
	await get_tree().create_timer(notification_cooldown).timeout
	set_can_arrive()

func clear_notifications() -> void:
	reset_amount()
	set_inbox_cleared()
	player.control.hide()

func is_message_from_asuka() -> bool:
	var random_number: int = randi() % 100
	return random_number <= probability_of_asuka_messages

func set_notification_cooldown(new_value: int) -> void:
	notification_cooldown = new_value
#endregion

#region Inbox state
func set_inbox_state(new_state: Inbox) -> void:
	inbox_state = new_state
	print("Inbox -> ", get_inbox_state_value())

func get_inbox_state_value() -> String:
	match inbox_state:
		Inbox.DIRTY:
			return "INCOMING"
		Inbox.CLEARED:
			return "CLEARED"
		_:
			return "UNKNOWN"

func set_inbox_cleared() -> void:
	inbox_state = Inbox.CLEARED

func set_inbox_incoming() -> void:
	inbox_state = Inbox.DIRTY

func in_inbox_dirty() -> bool:
	return inbox_state == Inbox.DIRTY

func is_inbox_cleared() -> bool:
	return inbox_state == Inbox.CLEARED
#endregion

#region Notification state
func set_can_arrive() -> void:
	notification_state = Notification.CAN_ARRIVE

func set_cannot_arrive() -> void:
	notification_state = Notification.CANNOT_ARRIVE

func can_arrive() -> bool:
	return notification_state == Notification.CAN_ARRIVE

func cannot_arrive() -> bool:
	return notification_state == Notification.CANNOT_ARRIVE
#endregion

#region Notification counter
func get_amount() -> int:
	return notifications_amount

func increase_amount() -> void:
	notifications_amount += 1

func decrease_amount() -> void:
	notifications_amount -= 1

func set_amount(new_value: int) -> void:
	notifications_amount = new_value

func reset_amount() -> void:
	notifications_amount = 0
#endregion
