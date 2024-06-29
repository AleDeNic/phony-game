extends Control

@onready var home: Control = $Home
@onready var options: Control = $Options

func _ready() -> void:
	go_to_screen("home")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		go_to_screen("options")

func go_to_screen(screen: String) -> void:
	if screen == "home":
		home.visible = true
		options.visible = false
	elif screen == "options":
		home.visible = false
		options.visible = true

func _on_options_pressed() -> void:
	go_to_screen("options")

func _on_back_pressed() -> void:
	go_to_screen("home")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
