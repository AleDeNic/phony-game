extends CanvasLayer

#region VARIABLES
@onready var blur_vignette: ShaderMaterial = $BlurVignette.material as ShaderMaterial
@onready var color_vignette: ShaderMaterial = $ColorVignette.material as ShaderMaterial
@onready var fade_color: ColorRect = $FadeColor

var blur_inner: float = 0.8
var blur_radius: float = 0.25
var blur_outer: float = 0.7

var vignette_strength: float = 1.7
var vignette_inner: float = 0.17
var vignette_outer: float = 1.7

const STARTUP_BEGIN: int = 0
const STARTUP_END: int = 60
#endregion


#region INIT & PROCESSING
func _ready() -> void:
	startup_blur()
#endregion


#region EFFECTS
func startup_blur() -> void:
	var counter: int = 0
	while counter < STARTUP_END:
		blur_inner = map_range(counter, STARTUP_BEGIN, STARTUP_END, 0.0, 0.8)
		blur_radius = map_range(counter, STARTUP_BEGIN, STARTUP_END, 0.6, 0.25)
		blur_outer = map_range(counter, STARTUP_BEGIN, STARTUP_END, 0.35, 0.7)
		vignette_strength = map_range(counter, STARTUP_BEGIN, STARTUP_END, 2.0, 1.7)
		vignette_inner = map_range(counter, STARTUP_BEGIN, STARTUP_END, 0.0, 0.17)
		vignette_outer = map_range(counter, STARTUP_BEGIN, STARTUP_END, 1.4, 1.7)
		fade_color.modulate.a = map_range(counter, STARTUP_BEGIN, STARTUP_END, 1.0, 0.0)
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


func handle_phone_sickness_filter() -> void:
	blur_inner = map_range(Notifications.current_phone_sickness, Notifications.MIN_PHONE_SICKNESS, Notifications.MAX_PHONE_SICKNESS, 0.8, 0.4)
	blur_radius = map_range(Notifications.current_phone_sickness, Notifications.MIN_PHONE_SICKNESS, Notifications.MAX_PHONE_SICKNESS, 0.25, 0.3)
	blur_outer = map_range(Notifications.current_phone_sickness, Notifications.MIN_PHONE_SICKNESS, Notifications.MAX_PHONE_SICKNESS, 0.7, 0.5)

	blur_vignette.set_shader_parameter("blur_inner", blur_inner)
	blur_vignette.set_shader_parameter("blur_radius", blur_radius)
	blur_vignette.set_shader_parameter("blur_outer", blur_outer)
#endregion

#region UTILS
func map_range(value: float, from_min: float, from_max: float, to_min: float, to_max: float) -> float:
	if from_max == from_min:
		return to_min

	var normalized_value: float = (value - from_min) / (from_max - from_min)

	if to_max > to_min:
		return normalized_value * (to_max - to_min) + to_min
	else:
		return (1.0 - normalized_value) * (to_min - to_max) + to_max
#endregion
