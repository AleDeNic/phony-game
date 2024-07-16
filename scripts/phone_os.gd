extends Control

@onready var top_bar: Control = $PhoneSize/TopBar
@onready var bottom_bar: Control = $PhoneSize/BottomBar
@onready var apps: Control = $PhoneSize/Apps
@onready var settings: Control = $PhoneSize/Settings
@onready var camera: Control = $PhoneSize/Camera
@onready var chat: Control = $PhoneSize/Chat
@onready var battery_bar: ProgressBar = $PhoneSize/TopBar/MarginContainer/HBoxContainer/BatteryBar
@onready var battery_timer: Timer = $PhoneSize/TopBar/MarginContainer/HBoxContainer/BatteryBar/BatteryTimer
@onready var default_message: RichTextLabel = $PhoneSize/Chat/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/DefaultMessage
@onready var default_player_message: RichTextLabel = $PhoneSize/Chat/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/DefaultPlayerMessage
@onready var background: ColorRect = $PhoneSize/Background
@onready var black_background: ColorRect = $PhoneSize/BlackBackground
@onready var notification_button: Button = $PhoneSize/TopBar/MarginContainer/HBoxContainer/NotificationButton
@onready var clock: Label = $PhoneSize/TopBar/MarginContainer/HBoxContainer/Clock
@onready var scroll_container: ScrollContainer = $PhoneSize/Chat/MarginContainer/VBoxContainer/ScrollContainer
@onready var input_message: LineEdit = $PhoneSize/Chat/MarginContainer/VBoxContainer/HBoxContainer/InputMessage
@onready var cant_leave_alert: Label = $CantLeaveAlert
@onready var phone_frame: Sprite2D = $PhoneSize/PhoneFrame
@onready var gradient_top: Sprite2D = $PhoneSize/TopBar/GradientTop
@onready var gradient_bottom: Sprite2D = $PhoneSize/BottomBar/GradientBottom


@export var max_battery: float = 30.0
@export var max_time: float = 59
@export var current_time: float = 12.0

@export_group("Messages colors")
@export var asuka_color: String = "#FF3344"
@export var random_color: String

# ----- INITIALIZATION AND PHYSICS -----

func _ready() -> void:
	setup_battery()
	reset_screens()
	battery_and_clock_coroutine()
	scroll_container.set_deferred("scroll_vertical", 600)
	turn_off_phone_visuals()
	cant_leave_alert.visible = false
	notification_button.visible = false
	NotificationsManager.connect("notification", Callable(self, "spawn_new_asuka_message"))
	
	#if Input.is_action_just_pressed("ui_cancel"):
		#PlayerManager.set_player_focusing_on_phone()
		#go_to_screen(settings)

func battery_and_clock_coroutine() -> void:
	while true:
		await get_tree().create_timer(0.1).timeout
		handle_battery()
		handle_clock()

# ----- HANDLE SCREENS -----

func go_to_screen(screen: Control) -> void:
	reset_screens()
	screen.visible = true
	PhoneManager.set_phone_state(PhoneManager.PhoneState[screen.name.to_upper()])
	if !PhoneManager.is_phone_in_apps():
		bottom_bar.visible = true

func reset_screens() -> void:
	top_bar.visible = true
	bottom_bar.visible = false
	apps.visible = false
	settings.visible = false
	camera.visible = false
	chat.visible = false
	chat.visible = false

func turn_off_phone() -> void:
	PhoneManager.set_phone_discharged()
	NotificationsManager.clear_notifications()
	reset_screens()
	top_bar.visible = false


# ----- SIGNALS -----

func _on_settings_pressed() -> void:
	go_to_screen(settings)

func _on_back_pressed() -> void:
	go_to_screen(apps)

func _on_home_pressed() -> void:
	go_to_screen(apps)

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)

func _on_camera_pressed() -> void:
	go_to_screen(camera)

func _on_chat_pressed() -> void:
	go_to_screen(chat)
	NotificationsManager.clear_notifications()
	notification_button.visible = false
	scroll_container_to_bottom()

func _on_notification_button_pressed() -> void:
	go_to_screen(chat)
	NotificationsManager.clear_notifications()
	notification_button.visible = false
	scroll_container_to_bottom()

func _on_input_message_text_submitted(new_text: String) -> void:
	spawn_new_player_message(new_text)
	input_message.clear()

func _on_send_message_pressed() -> void:
	spawn_new_player_message(input_message.text)
	input_message.clear()


# ----- MESSAGES -----

func spawn_new_asuka_message() -> void:
	var new_message = default_message.duplicate() as RichTextLabel
	var parent = default_message.get_parent()
	parent.add_child(new_message)
	parent.move_child(new_message, parent.get_child_count() - 1)
	new_message.visible = true
	var message_sender: String

	if NotificationsManager.is_message_from_asuka():
		message_sender = "Asuka"
	else:
		message_sender = generate_mysterious_words(7, 7)

	new_message.text = "[color=" + asuka_color + "]" + message_sender + ":[/color]   " + generate_mysterious_words(50, 10) + "  [i][color=gray] 8:" + str(int(current_time)).pad_zeros(2) + " am[/color][/i]"
	default_message = new_message
	notification_button.visible = true

func spawn_new_player_message(message_text: String) -> void:
	var new_player_message = default_player_message.duplicate() as RichTextLabel
	var parent = default_player_message.get_parent()
	
	parent.add_child(new_player_message)
	parent.move_child(new_player_message, parent.get_child_count() - 1)
	
	new_player_message.visible = true
	new_player_message.text = message_text  + "  [i][color=white] 8:" + str(int(current_time)).pad_zeros(2) + " am[/color][/i]"
	default_player_message = new_player_message
	
	call_deferred("scroll_container_to_bottom")

	print("Notification arrived")

func scroll_container_to_bottom() -> void:
	await get_tree().create_timer(0.1).timeout
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value


# ----- CLOCK AND BATTERY-----

func setup_battery() -> void:
	battery_bar.max_value = max_battery
	battery_timer.wait_time = max_battery
	battery_timer.start()
	battery_timer.paused = true
	handle_battery()

func handle_battery() -> void:
	if !PhoneManager.is_phone_discharged():
		battery_timer.paused = !PhoneManager.is_battery_active()
		battery_bar.value = battery_timer.time_left
		if battery_bar.value == 0:
			turn_off_phone()

func handle_clock() -> void:
	current_time = map_range(battery_bar.value, max_battery, 0.0, 12, 59)
	clock.text = "8:" + str(int(current_time)).pad_zeros(2) + " am"


# ----- PHONE VISUALS -----

func turn_on_phone_visuals() -> void:
	phone_frame.visible = true
	background.visible = true
	gradient_top.visible = true
	gradient_bottom.visible = true

func turn_off_phone_visuals() -> void:
	phone_frame.visible = false
	background.visible = false
	gradient_top.visible = false
	gradient_bottom.visible = false


# ----- TOOLTIP -----

func display_cant_leave_alert() -> void:
	cant_leave_alert.visible = true

func hide_cant_leave_alert() -> void:
	cant_leave_alert.visible = false


# ----- UTILS -----

func map_range(value: float, from_min: float, from_max: float, to_min: float, to_max: float) -> float:
	return (value - from_min) / (from_max - from_min) * (to_max - to_min) + to_min

func generate_mysterious_words(total_length: int, max_word_length: int) -> String:
	var characters = "!@#$%^&*()_+-=[]{}|;:,.<>?/~★✦✧✩✪✫✬✭✮✯✰†‡✞✟✠"
	var code = ""
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var current_word_length = 0
	
	while code.length() < total_length:
		if current_word_length >= max_word_length or (current_word_length > 0 and rng.randf() < 0.2):
			code += " "
			current_word_length = 0
		else:
			var random_char = characters[rng.randi() % characters.length()]
			code += random_char
			current_word_length += 1
	
	# Trim leading/trailing spaces and ensure exact length
	code = code.strip_edges()
	if code.length() > total_length:
		code = code.substr(0, total_length)
	
	return code


	




