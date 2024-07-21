extends Camera2D

#region VARIABLES
const PHONE_ZOOM_SPEED: float = 3.0
const ASUKA_ZOOM_SPEED: float = 1.2
const RESET_ZOOM_SPEED: float = 4.0

const PHONE_ZOOM_VALUE: Vector2 = Vector2(0.8, 0.8)
const ASUKA_ZOOM_VALUE: Vector2 = Vector2(1.3, 1.3)
const DEFAULT_ZOOM_VALUE: Vector2 = Vector2(1, 1)

var target_zoom: Vector2
var is_zooming: bool = false
var current_zoom_speed: float
#endregion


#region INIT & PROCESS
func _ready() -> void:
	zoom = DEFAULT_ZOOM_VALUE
	current_zoom_speed = ASUKA_ZOOM_SPEED
	target_zoom = DEFAULT_ZOOM_VALUE


func _physics_process(delta: float) -> void:
	if is_zooming:
		zoom = zoom.lerp(target_zoom, current_zoom_speed * delta)
		zoom = zoom.clamp(PHONE_ZOOM_VALUE, ASUKA_ZOOM_VALUE)
		if zoom.distance_to(target_zoom) < 0.001:
			zoom = target_zoom
			is_zooming = false
#endregion


func set_camera_zoom(zoom_value: Vector2, zoom_speed: float) -> void:
	if target_zoom != zoom_value:
		target_zoom = zoom_value
		current_zoom_speed = zoom_speed
		is_zooming = true
