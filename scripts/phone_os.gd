extends Control

const APPS_SCREEN: String       = "APPS"
const CHAT_SCREEN: String       = "CHAT"
const SETTINGS_SCREEN: String   = "SETTINGS"
const CAMERA_SCREEN: String     = "CAMERA"
const ASUKA_COLOR: String       = "#FF1A4D"
const STRANGER_COLOR: String    = "#5973FF"
const MessageScene: PackedScene = preload("res://scenes/balloons/phone_chat.tscn")
# ---- PHONE LAYOUT ----
@onready var top_bar: Control = $PhoneSize/TopBar
@onready var bottom_bar: Control = $PhoneSize/BottomBar
@onready var gradient_top: Sprite2D = $PhoneSize/TopBar/GradientTop
@onready var gradient_bottom: Sprite2D = $PhoneSize/BottomBar/GradientBottom
@onready var clock: Label = $PhoneSize/TopBar/MarginContainer/HBoxContainer/Clock
@onready var notification_button: Button = $PhoneSize/TopBar/MarginContainer/HBoxContainer/NotificationButton
@onready var home_widget: RichTextLabel = $PhoneSize/Apps/MarginContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/HomeWidget
# ---- SCREENS ----
@onready var apps: Control = $PhoneSize/Apps
@onready var settings: Control = $PhoneSize/Settings
@onready var camera: Control = $PhoneSize/Camera
@onready var chat: Control = $PhoneSize/Chat
@onready var coming_soon: Control = $PhoneSize/ComingSoon
# ---- BATTERY ----
@onready var battery_depletion_dampener: float = 10.0
@onready var battery_bar: ProgressBar = $PhoneSize/TopBar/MarginContainer/HBoxContainer/BatteryBar
@onready var battery_timer: Timer = $PhoneSize/TopBar/MarginContainer/HBoxContainer/BatteryBar/BatteryTimer

@export var max_battery: float = 5.0

# max_battery = clamp(dialogue_length / 100.0, 5.0, 60.0) <- this can be useful to clamp the battery life to a max value

#----- TIMER -----
@onready var update_timer: Timer

var elapsed_seconds: float = 0.0

@export var minute_dutation: int = 6 # how many seconds a minute lasts in game

# ---- CHAT ----
@onready var messages_resource          = load("res://dialogues/asuka_messages.dialogue")
@onready var default_message: RichTextLabel = $PhoneSize/Chat/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/DefaultMessage
@onready var default_player_message: RichTextLabel = $PhoneSize/Chat/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/DefaultPlayerMessage
# ---- BACKGROUND ----
@onready var background: ColorRect = $PhoneSize/Background
@onready var black_background: ColorRect = $PhoneSize/BlackBackground
@onready var scroll_container: ScrollContainer = $PhoneSize/Chat/MarginContainer/VBoxContainer/ScrollContainer
@onready var input_message: LineEdit = $PhoneSize/Chat/MarginContainer/VBoxContainer/HBoxContainer/InputMessage
@onready var cant_leave_alert: Label = $CantLeaveAlert
@onready var phone_frame: Sprite2D = $PhoneSize/PhoneFrame

@export_group("Messages colors")
@export var asuka_color: String = ASUKA_COLOR
@export var stranger_color: String = STRANGER_COLOR
#@export var random_color: String

var used_message_ids: Dictionary = {}
var asuka_messages: Array        = []


func _ready() -> void:
	setup_battery()
	reset_screens()
	setup_update_timer()
	get_random_asuka_messages(messages_resource)

	scroll_container.set_deferred("scroll_vertical", 600)

	turn_off_phone_visuals()

	cant_leave_alert.visible = false
	notification_button.visible = false

	NotificationsManager.connect("notification", Callable(self, "_spawn_new_asuka_message"))


func setup_update_timer() -> void:
	if not has_node("UpdateTimer"):
		update_timer = Timer.new()
		update_timer.name = "UpdateTimer"
		add_child(update_timer)
	update_timer.connect("timeout", Callable(self, "_on_update_timer_timeout"))
	update_timer.start(0.1)


func _on_update_timer_timeout() -> void:
	elapsed_seconds += 0.1
	handle_battery()
	handle_clock(8, 12)
	home_widget.text = clock.text


func reset_screens() -> void:
	top_bar.visible = true
	bottom_bar.visible = false
	apps.visible = false
	settings.visible = false
	camera.visible = false
	chat.visible = false
	coming_soon.visible = false


func turn_off_phone() -> void:
	PhoneManager.set_phone_discharged()
	NotificationsManager.clear_notifications()
	reset_screens()
	bottom_bar.visible = false


# ---- NAVIGATION ----
func go_to_screen(screen: Control) -> void:
	reset_screens()
	screen.visible = true
	if !PhoneManager.is_phone_discharged():
		PhoneManager.set_phone_state(PhoneManager.PhoneState[screen.name.to_upper()])
		if !PhoneManager.is_phone_in_apps():
			bottom_bar.visible = true
	else:
		bottom_bar.visible = false


func _on_settings_pressed() -> void:
	go_to_screen(settings)


func _on_back_pressed() -> void:
	go_to_screen(apps)


func _on_home_pressed() -> void:
	go_to_screen(apps)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_fullscreen_toggled(toggled_on: bool) -> void:
	DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN if toggled_on else DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)


func _on_camera_pressed() -> void:
	go_to_screen(coming_soon)


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


# ---- CHAT ----
func _on_input_message_text_submitted(new_text: String) -> void:
	spawn_new_player_message(new_text)
	input_message.clear()


func _on_send_message_pressed() -> void:
	spawn_new_player_message(input_message.text)
	input_message.clear()


func _spawn_new_asuka_message() -> void:
	var new_message: RichTextLabel = default_message.duplicate() as RichTextLabel
	var parent: Node               = default_message.get_parent()
	parent.add_child(new_message)
	parent.move_child(new_message, parent.get_child_count() - 1)
	new_message.visible = true
	
	var message_sender: String
	if NotificationsManager.is_message_from_asuka():
		message_sender = "(✫/~✰?"
		new_message.text = "[color=%s]%s:[/color] %s    [i][color=gray]" % [asuka_color, message_sender, get_random_asuka_message()] + clock.text + "[/color][/i]"
	else:
		message_sender = generate_mysterious_words(7, 7)
		new_message.text = "[color=%s]%s:[/color] %s    [i][color=gray]" % [stranger_color, message_sender, generate_mysterious_words(50, 8)] + clock.text + "[/color][/i]"
	default_message = new_message
	notification_button.visible = true


func spawn_new_player_message(message_text: String) -> void:
	var new_player_message: RichTextLabel = default_player_message.duplicate() as RichTextLabel
	var parent: Node                      = default_player_message.get_parent()
	parent.add_child(new_player_message)
	parent.move_child(new_player_message, parent.get_child_count() - 1)
	new_player_message.visible = true
	new_player_message.text = "%s    [i][color=white]" % [message_text] + clock.text + "[/color][/i]"
	default_player_message = new_player_message
	call_deferred("scroll_container_to_bottom")


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


func display_cant_leave_alert() -> void:
	cant_leave_alert.visible = true


func hide_cant_leave_alert() -> void:
	cant_leave_alert.visible = false


# ---- CLOCK AND BATTERY ----
func setup_battery() -> void:
	var dialogue_resource    = load("res://dialogues/asuka.dialogue")
	var dialogue_length: int = calculate_dialogue_length(dialogue_resource)
	max_battery = dialogue_length / battery_depletion_dampener
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
			turn_off_phone_visuals()


# AleDeNic! Azazello! QuanticMoth! You can edit the starting time! It's set to 8:00 am by default.
func handle_clock(starting_hour: int = 8, starting_minute: int = 0) -> void:
	var total_minutes: int = int(elapsed_seconds / minute_dutation) + starting_minute
	var hours: int         = (total_minutes / 60 + starting_hour) % 24
	var minutes: int       = total_minutes % 60

	var period: String = "am" if hours < 12 else "pm"
	hours = hours % 12
	if hours == 0:
		hours = 12

	clock.text = "%d:%02d %s" % [hours, minutes, period]


# ---- UTILS ----
func generate_mysterious_words(total_length: int, max_word_length: int) -> String:
	var characters: String = "!@#$%^&*()_+-=[]{}|;:,.<>?/~★✦✧✩✪✫✬✭✮✯✰†‡✞✟✠"
	var code: String       = ""
	var rng                = RandomNumberGenerator.new()
	rng.randomize()

	var current_word_length: int = 0

	while code.length() < total_length:
		if current_word_length >= max_word_length or (current_word_length > 0 and rng.randf() < 0.2):
			code += " "
			current_word_length = 0
		else:
			var random_char: String = characters[rng.randi() % characters.length()]
			code += random_char
			current_word_length += 1

	return code.strip_edges().substr(0, total_length)


func scroll_container_to_bottom() -> void:
	await get_tree().create_timer(0.1).timeout
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value


# Calculates the length of the dialogue based on the dialogue resource!
func calculate_dialogue_length(resource: DialogueResource) -> int:
	var total_length: int = 0
	for line_id in resource.lines.keys():
		var line = resource.lines[line_id]
		if "type" in line and line["type"] == "dialogue":
			total_length += line["text"].length()
	return total_length


func get_random_asuka_messages(resource: DialogueResource) -> void:
	for line_id in resource.lines.keys():
		var line = resource.lines[line_id]
		if "type" in line and line["type"] == "dialogue":
			asuka_messages.append(line["text"])
	return


func get_random_asuka_message() -> String:
	if asuka_messages.size() > 0:
		var random_index: int      = randi() % asuka_messages.size()
		var random_message: String = asuka_messages[random_index]
		asuka_messages.pop_at(random_index)
		return random_message
	return "But he never came."


func _on_video_pressed() -> void:
	go_to_screen(coming_soon)


func _on_music_pressed() -> void:
	go_to_screen(coming_soon)


func _on_gaming_pressed() -> void:
	go_to_screen(coming_soon)
