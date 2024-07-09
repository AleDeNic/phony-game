extends Camera2D

@onready var player_manager: Node = get_node("/root/World/PlayerManager")

@export_group("Speed values")
@export var phone_zoom_speed: float = 3.0
@export var asuka_zoom_speed: float = 1.2
@export var window_zoom_speed: float = 0.8
@export var reset_zoom_speed: float = 4.0

@export_group("Zoom values")
@export var phone_zoom_value = Vector2(0.8, 0.8)
@export var asuka_zoom_value = Vector2(1.3, 1.3)
@export var window_zoom_value = Vector2(1.2, 1.2)
@export var default_zoom_value = Vector2(1, 1)

var target_zoom: Vector2
var is_zooming: bool = false
var current_zoom_speed: float


# ----- INITIALIZATION AND PHYSICS -----

func _ready() -> void:
	zoom = default_zoom_value
	current_zoom_speed = asuka_zoom_speed
	target_zoom = default_zoom_value

func _physics_process(delta: float) -> void:
	if is_zooming == true:
		zoom = zoom.lerp(target_zoom, current_zoom_speed * delta)
		zoom = clamp(zoom, phone_zoom_value, window_zoom_value)
		if abs(zoom.x - target_zoom.x) < 0.001:
			zoom = target_zoom
			is_zooming = false


# ----- SET ZOOM -----

func set_camera_zoom(zoom_value, zoom_speed) -> void:
	if target_zoom != zoom_value:
		target_zoom = zoom_value
		current_zoom_speed = zoom_speed
		is_zooming = true
		#print(target_zoom)
