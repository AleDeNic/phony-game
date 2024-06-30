extends Control

@onready var home: Control = $Home
@onready var options: Control = $Options
@onready var game_manager: Node2D = %GameManager
@onready var battery_bar: ProgressBar = $Battery/BatteryMargin/BateryVBox/BatteryBar
@onready var battery_timer: Timer = $Battery/BatteryTimer

var phone_state: String

func _ready() -> void:
	phone_state = "off"
	battery_bar.max_value = game_manager.max_battery
	battery_timer.wait_time = game_manager.max_battery
	battery_timer.start()
	battery_bar.value = battery_timer.time_left
	handle_battery(phone_state)
	go_to_screen("home")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		go_to_screen("options")
	
	handle_battery(phone_state)

func go_to_screen(screen: String) -> void:
	if screen == "home":
		home.visible = true
		options.visible = false
	elif screen == "options":
		home.visible = false
		options.visible = true
		
func handle_battery(phone_state) -> void:
	if phone_state == "menu":
		battery_timer.paused = false
		battery_bar.value = battery_timer.time_left
	else:
		battery_timer.paused = true

func _on_options_pressed() -> void:
	phone_state = "options"
	go_to_screen("options")

func _on_back_pressed() -> void:
	phone_state = "menu"
	go_to_screen("home")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
