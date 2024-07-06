extends Node

@export var target_width: int = 1920
@export var target_height: int = 1080
@export var max_scale: float = 1.0  # Maximum allowed scale

func _ready():
	get_tree().root.connect("size_changed", Callable(self, "_on_viewport_size_changed"))
	_on_viewport_size_changed()

func _on_viewport_size_changed():
	var window_size = DisplayServer.window_get_size()
	var scale = min(window_size.x / float(target_width), window_size.y / float(target_height))
	
	# Limit the scale to prevent excessive zooming
	scale = min(scale, max_scale)
	
	var viewport = get_tree().root
	var scaled_size = Vector2i(int(target_width * scale), int(target_height * scale))
	var margins = (window_size - scaled_size) / 2
	
	# Set the scale of the viewport
	viewport.set_content_scale_factor(scale)
	
	# Update project settings
	ProjectSettings.set_setting("display/window/size/viewport_width", target_width)
	ProjectSettings.set_setting("display/window/size/viewport_height", target_height)
	ProjectSettings.set_setting("display/window/stretch/mode", "viewport")
	ProjectSettings.set_setting("display/window/stretch/aspect", "keep_aspect")
	
	# Force the viewport to update
	viewport.set_size(scaled_size)

	# Center the game window
	var screen_size = DisplayServer.screen_get_size()
	var centered_position = (screen_size - scaled_size) / 2
	DisplayServer.window_set_position(centered_position)
	DisplayServer.window_set_size(scaled_size)
