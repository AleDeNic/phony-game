extends Control

@onready var top_bar: Control = $PhoneSize/TopBar
@onready var bottom_bar: Control = $PhoneSize/BottomBar
@onready var apps: Control = $PhoneSize/Apps
@onready var settings: Control = $PhoneSize/Settings
@onready var camera: Control = $PhoneSize/Camera
@onready var chats: Control = $PhoneSize/Chats
@onready var asukachat: Control = $PhoneSize/AsukaChat
@onready var battery_bar: ProgressBar = $PhoneSize/TopBar/MarginContainer/HBoxContainer/BatteryBar
@onready var battery_timer: Timer = $PhoneSize/TopBar/MarginContainer/HBoxContainer/BatteryBar/BatteryTimer
@onready var player_01: Label = $PhoneSize/AsukaChat/MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer/Player01

@export var max_battery: float = 100.0

# ----- INITIALIZATION AND PHYSICS -----

func _ready() -> void:
	setup_battery()
	reset_screens()
	apps.visible = true
	NotificationsManager.connect("notification", Callable(self, "spawn_message"))

func _physics_process(_delta: float) -> void:
	handle_battery()
	if Input.is_action_just_pressed("ui_cancel"):
		PlayerManager.set_player_focusing_on_phone()
		go_to_screen(settings)
	#print_phone_state(phone_state)

func spawn_message() -> void:
	player_01.visible = true
	print("notification arrived")

# ----- BATTERY -----

func setup_battery() -> void:
	battery_bar.max_value = max_battery
	battery_timer.wait_time = max_battery
	battery_timer.start()
	battery_timer.paused = true
	handle_battery()

func handle_battery() -> void:
	if PhoneManager.is_battery_active():
		battery_timer.paused = false
	else:
		battery_timer.paused = true
	battery_bar.value = battery_timer.time_left


func restore_phone_state():
	PhoneManager.set_phone_in_apps()
	go_to_screen(apps)
	#match true:
		#apps.visible:
			#PhoneManager.set_phone_in_apps()
		#settings.visible:
			#PhoneManager.set_phone_in_settings()
		#camera.visible:
			#PhoneManager.set_phone_in_camera()
		#chats.visible:
			#PhoneManager.set_phone_in_chats()
		#asukachat.visible:
			#PhoneManager.set_phone_in_asukachat()


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
	chats.visible = false
	asukachat.visible = false


# ----- SIGNALS -----
func _on_settings_pressed() -> void:
	go_to_screen(settings)

func _on_back_pressed() -> void:
	if PhoneManager.is_phone_in_asukachat():
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
	go_to_screen(asukachat)
