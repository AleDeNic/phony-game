extends Camera2D

@export_group("Camera values")
@export var zoom_in_speed = 0.1  # Default zoom speed
@export var zoom_out_speed = 0.1
@export var reset_zoom_speed = 3.0
@export var zoom_phone = Vector2(0.5, 0.5)
@export var zoom_asuka = Vector2(1.5, 1.5)
@export var zoom_window = Vector2(2.5, 2.5)
@export var zoom_default = Vector2(1, 1)

# Internal state
var target_zoom: Vector2
var is_zooming = false
var current_zoom_speed = zoom_in_speed  # Variable to control the zoom speed dynamically

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zoom = zoom_default
	target_zoom = zoom_default

func _process(delta: float) -> void:
	if is_zooming:
		# Smoothly interpolate the zoom level towards the target zoom using exponential interpolation
		zoom = zoom.lerp(target_zoom, current_zoom_speed * delta)
		# Clamp the zoom to avoid over-zooming
		zoom = clamp(zoom, zoom_phone, zoom_window)
		# Stop zooming if the target zoom is reached within a small tolerance
		if abs(zoom.x - target_zoom.x) < 0.001 and abs(zoom.y - target_zoom.y) < 0.001:
			zoom = target_zoom  # Ensure exact final zoom
			is_zooming = false

func start_zoom_asuka():
	if target_zoom != zoom_asuka:  # Avoid starting a new zoom if already at target
		target_zoom = zoom_asuka
		current_zoom_speed = zoom_in_speed  # Use zoom in speed
		is_zooming = true
		print("zoom asuka")

func start_zoom_window():
	if target_zoom != zoom_window:  # Avoid starting a new zoom if already at target
		target_zoom = zoom_window
		current_zoom_speed = zoom_in_speed  # Use zoom in speed
		is_zooming = true
		print("zoom window")

func start_zoom_phone():
	if target_zoom != zoom_phone:  # Avoid starting a new zoom if already at target
		target_zoom = zoom_phone
		current_zoom_speed = zoom_out_speed  # Use zoom out speed
		is_zooming = true
		print("zoom phone")

func reset_zoom():
	if target_zoom != zoom_default:  # Avoid resetting if already at default
		target_zoom = zoom_default
		current_zoom_speed = reset_zoom_speed  # Set a faster zoom speed for reset
		is_zooming = true
		print("zoom reset")

# Function to check if the zoom is in progress
func is_zooming_in_progress() -> bool:
	return is_zooming
