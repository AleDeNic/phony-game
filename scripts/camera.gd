extends Camera2D

@export_group("Speed values")
@export var asuka_zoom_speed: float = 0.1
@export var window_zoom_speed: float = 0.1
@export var phone_zoom_speed: float = 0.15
@export var reset_zoom_speed: float = 2.0
@export_group("Zoom values")
@export var phone_zoom_value = Vector2(0.6, 0.6)
@export var asuka_zoom_value = Vector2(1.6, 1.6)
@export var window_zoom_value = Vector2(2.5, 2.5)
@export var default_zoom_value = Vector2(1, 1)

var target_zoom: Vector2
var is_zooming: bool = false
var current_zoom_speed = asuka_zoom_speed  # Variable to control the zoom speed dynamically

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zoom = default_zoom_value
	target_zoom = default_zoom_value

func _process(delta: float) -> void:
	if is_zooming:
		# Smoothly interpolate the zoom level towards the target zoom using exponential interpolation
		zoom = zoom.lerp(target_zoom, current_zoom_speed * delta)
		# Clamp the zoom to avoid over-zooming (min and max zoom values)
		zoom = clamp(zoom, phone_zoom_value, window_zoom_value)
		# Stop zooming if the target zoom is reached within a small tolerance
		if abs(zoom.x - target_zoom.x) < 0.001 and abs(zoom.y - target_zoom.y) < 0.001:
			zoom = target_zoom  # Ensure exact final zoom
			is_zooming = false

func start_zoom(zoom_value, zoom_speed) -> void:
	if target_zoom != zoom_value:  # Avoid resetting if already at default
		target_zoom = zoom_value
		current_zoom_speed = zoom_speed
		is_zooming = true
