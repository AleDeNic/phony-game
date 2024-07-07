extends Control

@onready var top_bar: Control = $PhoneSize/TopBar
@onready var bottom_bar: Control = $PhoneSize/BottomBar
@onready var apps: Control = $PhoneSize/Apps
@onready var options: Control = $PhoneSize/Options
@onready var camera: Control = $PhoneSize/Camera
@onready var chats: Control = $PhoneSize/Chats
@onready var asuka_chat: Control = $PhoneSize/AsukaChat
@onready var game_manager: Node2D = %GameManager
@onready var battery_bar: ProgressBar = $PhoneSize/TopBar/MarginContainer/HBoxContainer/BatteryBar
@onready var battery_timer: Timer = $PhoneSize/TopBar/MarginContainer/HBoxContainer/BatteryBar/BatteryTimer
@onready var phone: Area2D = get_node("/root/World/Phone")
@onready var player: CharacterBody2D = %Player

var phone_state: String

func _ready() -> void:
	phone_state = "Off"
	setup_battery()
	reset_screens()
	apps.visible = true

func _process(_delta: float) -> void:
	handle_battery(phone_state)
	#print(phone_state)
	if Input.is_action_just_pressed("ui_cancel"):
		phone.state = "phone_zooming_in"
		go_to_screen(options)

func go_to_screen(screen: Control) -> void:
	reset_screens()
	screen.visible = true
	phone_state = screen.get_name()
	if phone_state != "Apps":
		bottom_bar.visible = true

func reset_screens() -> void:
	top_bar.visible = true
	bottom_bar.visible = false
	apps.visible = false
	options.visible = false
	camera.visible = false
	chats.visible = false
	asuka_chat.visible = false

func setup_battery() -> void:
	battery_bar.max_value = game_manager.max_battery
	battery_timer.wait_time = game_manager.max_battery
	battery_timer.start()
	battery_timer.paused = true
	handle_battery(phone_state)

func handle_battery(state) -> void:
	if state in ["Off", "Options"]:
		battery_timer.paused = true
	else:
		battery_timer.paused = false
	battery_bar.value = battery_timer.time_left

func _on_options_pressed() -> void:
	go_to_screen(options)

func _on_back_pressed() -> void:
	if phone_state == "AsukaChat":
		go_to_screen(chats)
	else:
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

func _on_chats_pressed() -> void:
	go_to_screen(chats)

func _on_asuka_pressed() -> void:
	go_to_screen(asuka_chat)

func _on_mouse_exited() -> void:
	if player.state != "free":
		phone_state = "Off"
		phone.exit_phone()





