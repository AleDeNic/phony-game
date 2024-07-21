extends Control

#TODO: Handle phone exit in a clearer way
@onready var phone: Area2D = get_node("/root/World/Parallax/Phone/Phone")
#region VARIABLES
const APPS_SCREEN: String = "APPS"
const CHAT_SCREEN: String = "CHAT"
const SETTINGS_SCREEN: String = "SETTINGS"
const CAMERA_SCREEN: String = "CAMERA"
# ----- COLORS -----
const ASUKA_COLOR: String = "#FF1A4D"
const STRANGER_COLOR: String = "#5973FF"
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
# ----- TIMER -----
@onready var update_timer: Timer
@export var minute_dutation: int = 6 # how many seconds a minute lasts in game
var elapsed_seconds: float = 0.0
# ---- CHAT ----
@onready var messages_resource = load("res://dialogues/asuka_messages.dialogue")
@onready var default_message: RichTextLabel = $PhoneSize/Chat/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/DefaultMessage
@onready var default_player_message: RichTextLabel = $PhoneSize/Chat/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/DefaultPlayerMessage
# ---- BACKGROUND ----
@onready var background: ColorRect = $PhoneSize/Background
@onready var black_background: ColorRect = $PhoneSize/BlackBackground
@onready var scroll_container: ScrollContainer = $PhoneSize/Chat/MarginContainer/VBoxContainer/ScrollContainer
@onready var input_message: LineEdit = $PhoneSize/Chat/MarginContainer/VBoxContainer/HBoxContainer/InputMessage
@onready var cant_leave_alert: Label = $CantLeaveAlert
@onready var phone_frame: Sprite2D = $PhoneSize/PhoneFrame
# ----- MESSAGES -----
var used_message_ids: Dictionary = {}
var asuka_messages: Array = []
#endregion


#region SETUP
func _ready() -> void:
	setup_battery()
	reset_screens()
	setup_update_timer()
	load_asuka_messages(messages_resource)
	scroll_container.set_deferred("scroll_vertical", 600)
	turn_off_phone_visuals()
	cant_leave_alert.hide()
	notification_button.hide()
	Notifications.connect("notification_arrived", Callable(self, "_spawn_new_asuka_message"))
#endregion


#region TIMER
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
#endregion


#region NAVIGATION
func reset_screens() -> void:
	top_bar.show()
	bottom_bar.hide()
	apps.hide()
	settings.hide()
	camera.hide()
	chat.hide()
	coming_soon.hide()

func turn_off_phone() -> void:
	Phone.set_phone_discharged()
	Notifications.clear_notifications()
	reset_screens()
	bottom_bar.hide()


# ---- NAVIGATION ----
func go_to_screen(screen: Control) -> void:
	reset_screens()
	screen.show()
	if not Phone.is_discharged():
		Phone.set_phone_state(Phone.State[screen.name.to_upper()])
		if not Phone.in_apps():
			bottom_bar.show()
	else:
		bottom_bar.show()
#endregion


#region BUTTONS

# ----- HOME APPS -----
func _on_settings_pressed() -> void:
	go_to_screen(settings)

func _on_camera_pressed() -> void:
	go_to_screen(coming_soon)

func _on_video_pressed() -> void:
	go_to_screen(coming_soon)

func _on_music_pressed() -> void:
	go_to_screen(coming_soon)

func _on_gaming_pressed() -> void:
	go_to_screen(coming_soon)

func _on_chat_pressed() -> void:
	go_to_screen(chat)
	Notifications.clear_notifications()
	notification_button.hide()
	scroll_container_to_bottom()

# ----- SETTINGS -----
func _on_fullscreen_toggled(toggled_on: bool) -> void:
	DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN if toggled_on else DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)

func _on_reset_pressed() -> void:
	Asuka.reset_all()
	Phone.reset_all()
	Player.reset_all()
	Notifications.reset_all()
	Phases.reset_all()
	Audio.reset_all()
	phone.exit()
	get_tree().reload_current_scene()
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()

# ----- TOP BAR -----
func _on_notification_button_pressed() -> void:
	go_to_screen(chat)
	Notifications.clear_notifications()
	notification_button.hide()
	scroll_container_to_bottom()

# ----- BOTTOM BAR -----
func _on_back_pressed() -> void:
	go_to_screen(apps)

func _on_home_pressed() -> void:
	go_to_screen(apps)
#endregion


#region PHONE VISUALS
func turn_on_phone_visuals() -> void:
	phone_frame.show()
	background.show()
	gradient_top.show()
	gradient_bottom.show()

func turn_off_phone_visuals() -> void:
	phone_frame.hide()
	background.hide()
	gradient_top.hide()
	gradient_bottom.hide()
#endregion


#region CLOCK & BATTERY
func setup_battery() -> void:
	var dialogue_resource = load("res://dialogues/asuka.dialogue")
	var dialogue_length: int = calculate_dialogue_length(dialogue_resource)
	max_battery = dialogue_length / battery_depletion_dampener
	battery_bar.max_value = max_battery
	battery_timer.wait_time = max_battery
	battery_timer.start()
	battery_timer.paused = true
	handle_battery()

func handle_battery() -> void:
	if not Phone.is_discharged():
		battery_timer.paused = not Phone.is_battery_active()
		battery_bar.value = battery_timer.time_left
		if battery_bar.value == 0:
			turn_off_phone()
			turn_off_phone_visuals()

func handle_clock(starting_hour: int = 8, starting_minute: int = 0) -> void:
	var total_minutes: int = int(elapsed_seconds / minute_dutation) + starting_minute
	var hours: int = (total_minutes / 60 + starting_hour) % 24
	var minutes: int = total_minutes % 60

	var period: String = "am" if hours < 12 else "pm"
	hours = hours % 12
	if hours == 0:
		hours = 12

	clock.text = "%d:%02d %s" % [hours, minutes, period]
#endregion


#region UTILS
func generate_mysterious_words(total_length: int, max_word_length: int) -> String:
	var characters: String = "!@#$%^&*()_+-=[]{}|;:,.<>?/~★✦✧✩✪✫✬✭✮✯✰†‡✞✟✠"
	var code: String = ""
	var rng = RandomNumberGenerator.new()
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
#endregion


#region MESSAGES
func _on_input_message_text_submitted(new_text: String) -> void:
	spawn_new_player_message(new_text)
	input_message.clear()

func _on_send_message_pressed() -> void:
	spawn_new_player_message(input_message.text)
	input_message.clear()

func _spawn_new_asuka_message() -> void:
	var new_message: RichTextLabel = default_message.duplicate() as RichTextLabel
	var parent: Node = default_message.get_parent()
	parent.add_child(new_message)
	parent.move_child(new_message, parent.get_child_count() - 1)
	new_message.show()

	var message_sender: String
	if Notifications.is_message_from_asuka():
		message_sender = "(✫/~✰?"
		new_message.text = "[color=%s]%s:[/color] %s    [i][color=gray]" % [ASUKA_COLOR, message_sender, pick_random_asuka_message()] + clock.text + "[/color][/i]"
	else:
		message_sender = generate_mysterious_words(7, 7)
		new_message.text = "[color=%s]%s:[/color] %s    [i][color=gray]" % [STRANGER_COLOR, message_sender, generate_mysterious_words(50, 8)] + clock.text + "[/color][/i]"
	default_message = new_message
	notification_button.show()

func spawn_new_player_message(message_text: String) -> void:
	var new_player_message: RichTextLabel = default_player_message.duplicate() as RichTextLabel
	var parent: Node = default_player_message.get_parent()
	parent.add_child(new_player_message)
	parent.move_child(new_player_message, parent.get_child_count() - 1)
	new_player_message.show()
	new_player_message.text = "%s    [i][color=white]" % [message_text] + clock.text + "[/color][/i]"
	default_player_message = new_player_message
	call_deferred("scroll_container_to_bottom")

func calculate_dialogue_length(resource: DialogueResource) -> int:
	var total_length: int = 0
	for line_id in resource.lines.keys():
		var line = resource.lines[line_id]
		if "type" in line and line["type"] == "dialogue":
			total_length += line["text"].length()
	return total_length

func load_asuka_messages(resource: DialogueResource) -> void:
	for line_id in resource.lines.keys():
		var line = resource.lines[line_id]
		if "type" in line and line["type"] == "dialogue":
			asuka_messages.append(line["text"])
	return

func pick_random_asuka_message() -> String:
	if asuka_messages.size() > 0:
		var random_index: int = randi() % asuka_messages.size()
		var random_message: String = asuka_messages[random_index]
		asuka_messages.pop_at(random_index)
		return random_message
	return "But he never came."
#endregion

func display_cant_leave_alert() -> void:
	cant_leave_alert.show()

func hide_cant_leave_alert() -> void:
	cant_leave_alert.hide()
