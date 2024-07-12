extends CanvasLayer

@onready var blur_vignette: ShaderMaterial = $BlurVignette.material as ShaderMaterial
@onready var color_filter: ShaderMaterial = $ColorFilter.material as ShaderMaterial

@export var blur_level: float = 0.6
var panic_blur_inner: float = blur_level

var soft_light_color: Color
@export var color_amount: float = 0.6


# ----- PROCESSING!!! -----

func _physics_process(_delta: float) -> void:
	handle_panic_filter()
	change_color_filter(soft_light_color)


# ----- HANDLE FILTERS -----

func handle_panic_filter() -> void:
	if BrainManager.player_panic > BrainManager.panic_wait:
		panic_blur_inner = map_range(BrainManager.player_panic, BrainManager.panic_wait, BrainManager.max_panic, blur_level, 0.0)
		blur_vignette.set_shader_parameter("blur_inner", panic_blur_inner)
		#print(panic_blur_inner)

func change_color_filter(color_vector: Color) -> void:
	color_vector.a = color_amount
	color_filter.set_shader_parameter("overlay_color", color_vector)


# ----- UTILS -----

func map_range(value: float, from_min: float, from_max: float, to_min: float, to_max: float) -> float:
	return (value - from_min) / (from_max - from_min) * (to_max - to_min) + to_min
