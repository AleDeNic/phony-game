extends Control

enum PhoneState { OFF, APPS, OPTIONS, CAMERA, CHATS, ASUKACHAT }

@onready var top_bar: Control = $PhoneSize/TopBar
@onready var bottom_bar: Control = $PhoneSize/BottomBar
@onready var apps: Control = $PhoneSize/Apps
@onready var options: Control = $PhoneSize/Options
@onready var camera: Control = $PhoneSize/Camera
@onready var chats: Control = $PhoneSize/Chats
@onready var asukachat: Control = $PhoneSize/AsukaChat
@onready var player_manager: Node = %PlayerManager
@onready var battery_bar: ProgressBar = $PhoneSize/TopBar/MarginContainer/HBoxContainer/BatteryBar
@onready var battery_timer: Timer = $PhoneSize/TopBar/MarginContainer/HBoxContainer/BatteryBar/BatteryTimer

var phone_state: PhoneState = PhoneState.OFF

func _ready() -> void:
	reset_screens()
	apps.visible = true

	if not player_manager.is_node_ready():
		await player_manager.ready

	setup_battery()

func _physics_process(_delta: float) -> void:
	handle_battery()
	if Input.is_action_just_pressed("ui_cancel"):
		player_manager.set_player_state(player_manager.PlayerState.ZOOMING_IN)
		go_to_screen(options)


# ---------- PHONE STATE -----------
func set_phone_state(new_state: PhoneState) -> void:
	phone_state = new_state

func get_phone_state() -> PhoneState:
	return phone_state

func is_battery_active() -> bool:
	return phone_state not in [PhoneState.OFF, PhoneState.OPTIONS]





func go_to_screen(screen: Control) -> void:
	reset_screens()
	screen.visible = true
	set_phone_state(PhoneState[screen.name.to_upper()])
	if phone_state != PhoneState.APPS:
		bottom_bar.visible = true

func reset_screens() -> void:
	top_bar.visible = true
	bottom_bar.visible = false
	apps.visible = false
	options.visible = false
	camera.visible = false
	chats.visible = false
	asukachat.visible = false

func setup_battery() -> void:
	battery_bar.max_value = player_manager.max_battery
	battery_timer.wait_time = player_manager.max_battery
	battery_timer.start()
	battery_timer.paused = true
	handle_battery()

func handle_battery() -> void:
	battery_timer.paused = not is_battery_active()
	battery_bar.value = battery_timer.time_left

func _on_options_pressed() -> void:
	go_to_screen(options)

func _on_back_pressed() -> void:
	if phone_state == PhoneState.ASUKACHAT:
		go_to_screen(chats)
	else:
		go_to_screen(apps)

func _on_home_pressed() -> void:
	go_to_screen(apps)

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN if toggled_on else DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)

func _on_camera_pressed() -> void:
	go_to_screen(camera)

func _on_chats_pressed() -> void:
	go_to_screen(chats)

func _on_asuka_pressed() -> void:
	go_to_screen(asukachat)


func print_phone_state(state):
	match state:
		PhoneState.OFF:
			print("Phone state: OFF")
		PhoneState.APPS:
			print("Phone state: APPS")
		PhoneState.OPTIONS:
			print("Phone state: OPTIONS")
		PhoneState.CAMERA:
			print("Phone state: CAMERA")
		PhoneState.CHATS:
			print("Phone state: CHATS")
		PhoneState.ASUKACHAT:
			print("Phone state: ASUKACHAT")
