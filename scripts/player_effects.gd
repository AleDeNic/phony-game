extends CanvasLayer

@onready var blur_vignette: ShaderMaterial = $BlurVignette.material as ShaderMaterial
@onready var color_vignette: ShaderMaterial = $ColorVignette.material as ShaderMaterial
@onready var fade_color: ColorRect = $FadeColor

@export var blur_inner: float = 0.8
@export var blur_radius: float = 0.25
@export var blur_outer: float = 0.7

@export var vignette_strength: float = 1.7
@export var vignette_inner: float = 0.17
@export var vignette_outer: float = 1.7

@export var startup_begin: int = 0
@export var startup_end: int = 60

# ----- PROCESSING!!! ----

func _ready() -> void:
	startup_blur()

func startup_blur() -> void:
	var counter: int = 0
	while counter < startup_end:
		blur_inner = map_range(counter, startup_begin, startup_end, 0.0, 0.8)
		blur_radius = map_range(counter, startup_begin, startup_end, 0.6, 0.25)
		blur_outer = map_range(counter, startup_begin, startup_end, 0.35, 0.7)
		vignette_strength = map_range(counter, startup_begin, startup_end, 2.0, 1.7)
		vignette_inner = map_range(counter, startup_begin, startup_end, 0.0, 0.17)
		vignette_outer = map_range(counter, startup_begin, startup_end, 1.4, 1.7)
		fade_color.modulate.a = map_range(counter, startup_begin, startup_end, 1.0, 0.0)
		blur_vignette.set_shader_parameter("blur_inner", blur_inner)
		blur_vignette.set_shader_parameter("blur_radius", blur_radius)
		blur_vignette.set_shader_parameter("blur_outer", blur_outer)
		color_vignette.set_shader_parameter("vignette_strength", vignette_strength)
		color_vignette.set_shader_parameter("inner_radius", vignette_inner)
		color_vignette.set_shader_parameter("outer_radius", vignette_outer)
		counter += 1
		#print(counter)
		await get_tree().create_timer(0.01).timeout
	print("start coroutine")
	sickness_filter_coroutine()

func sickness_filter_coroutine() -> void:
	while true:
		handle_phone_sickness_filter()
		await get_tree().create_timer(0.1).timeout

# ----- HANDLE FILTERS -----

func handle_phone_sickness_filter() -> void:
	blur_inner = map_range(NotificationsManager.phone_sickness, NotificationsManager.min_phone_sickness, NotificationsManager.max_phone_sickness, 0.8, 0.4)
	blur_radius = map_range(NotificationsManager.phone_sickness, NotificationsManager.min_phone_sickness, NotificationsManager.max_phone_sickness, 0.25, 0.3)
	blur_outer = map_range(NotificationsManager.phone_sickness, NotificationsManager.min_phone_sickness, NotificationsManager.max_phone_sickness, 0.7, 0.5)

	blur_vignette.set_shader_parameter("blur_inner", blur_inner)
	blur_vignette.set_shader_parameter("blur_radius", blur_radius)
	blur_vignette.set_shader_parameter("blur_outer", blur_outer)


# ----- UTILS -----

#func map_range(value: float, from_min: float, from_max: float, to_min: float, to_max: float) -> float:
	#return (value - from_min) / (from_max - from_min) * (to_max - to_min) + to_min
	
func map_range(value: float, from_min: float, from_max: float, to_min: float, to_max: float) -> float:
	if from_max == from_min:
		return to_min  # Avoid division by zero

	# Normalize the input value within the source range
	var normalized_value = (value - from_min) / (from_max - from_min)

	# Calculate the mapped value within the target range
	if to_max > to_min:
		return normalized_value * (to_max - to_min) + to_min
	else:
		return (1.0 - normalized_value) * (to_min - to_max) + to_max


