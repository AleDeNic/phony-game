extends Control

@onready var apps: Control = $Apps
@onready var options: Control = $Options
@onready var camera: Control = $Camera
@onready var chats: Control = $Chats
@onready var game_manager: Node2D = %GameManager
@onready var battery_bar: ProgressBar = $TopBar/MarginContainer/HBoxContainer/BatteryBar
@onready var battery_timer: Timer = $TopBar/MarginContainer/HBoxContainer/BatteryBar/BatteryTimer

var phone_state: String

func _ready() -> void:
	phone_state = "off"
	battery_bar.max_value = game_manager.max_battery
	battery_timer.wait_time = game_manager.max_battery
	battery_timer.start()
	battery_bar.value = battery_timer.time_left
	handle_battery(phone_state)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		go_to_screen("options")
	
	handle_battery(phone_state)

func go_to_screen(screen: String) -> void:
	apps.visible = false
	options.visible = false
	camera.visible = false
	chats.visible = false
	if screen == "home" or screen == "off":
		apps.visible = true
	elif screen == "options":
		options.visible = true
	elif screen == "camera":
		camera.visible = true
	elif screen == "chats":
		chats.visible = true
		
func handle_battery(state) -> void:
	if state == "home":
		battery_timer.paused = false
		battery_bar.value = battery_timer.time_left
	else:
		battery_timer.paused = true

func _on_options_pressed() -> void:
	phone_state = "options"
	go_to_screen("options")

func _on_back_pressed() -> void:
	phone_state = "home"
	go_to_screen("home")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
		
func _on_camera_pressed() -> void:
	phone_state = "camera"
	go_to_screen("camera")

func _on_chats_pressed() -> void:
	phone_state = "chats"
	go_to_screen("chats")
