extends CanvasLayer

@onready var blur_vignette: ShaderMaterial = $BlurVignette.material as ShaderMaterial
@onready var color_filter: ShaderMaterial = $ColorFilter.material as ShaderMaterial
@onready var color_vignette: ShaderMaterial = $ColorVignette.material as ShaderMaterial


var soft_light_color: Color
@export var color_amount: float = 0.6

@export var blur_inner: float = 0.8
@export var blur_radius: float = 0.25
@export var blur_outer: float = 0.7


# ----- PROCESSING!!! -----

func _physics_process(_delta: float) -> void:
	handle_phone_sickness_filter()
	change_color_filter(soft_light_color)


# ----- HANDLE FILTERS -----

func handle_phone_sickness_filter() -> void:
	if NotificationsManager.phone_sickness > NotificationsManager.phone_sickness_wait:
		
		blur_inner = map_range(NotificationsManager.phone_sickness, NotificationsManager.phone_sickness_wait, NotificationsManager.max_phone_sickness, 0.8, 0.0)
		blur_radius = map_range(NotificationsManager.phone_sickness, NotificationsManager.phone_sickness_wait, NotificationsManager.max_phone_sickness, 0.25, 0.6)
		blur_outer = map_range(NotificationsManager.phone_sickness, NotificationsManager.phone_sickness_wait, NotificationsManager.max_phone_sickness, 0.7, 0.35)
		
		blur_vignette.set_shader_parameter("blur_inner", blur_inner)
		blur_vignette.set_shader_parameter("blur_radius", blur_radius)
		blur_vignette.set_shader_parameter("blur_outer", blur_outer)
		#print(phone_sickness_blur_inner)

func change_color_filter(color_vector: Color) -> void:
	color_vector.a = color_amount
	color_filter.set_shader_parameter("overlay_color", color_vector)


# ----- UTILS -----

func map_range(value: float, from_min: float, from_max: float, to_min: float, to_max: float) -> float:
	return (value - from_min) / (from_max - from_min) * (to_max - to_min) + to_min
