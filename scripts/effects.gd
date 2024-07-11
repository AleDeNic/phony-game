extends Control

@onready var stress_filter: ColorRect = $StressFilter
@onready var blur_fisheye: ShaderMaterial = $BlurFisheye.material as ShaderMaterial
@onready var blue_filter: ColorRect = $BlueFilter

var stress_level: float = 0.0
var target_lod: float = 3.5
var current_lod: float = 0.0
var current_lod_speed: float = 0.0
var current_blue: float = 0.0

const MIN_BLUE: float = 0.0
const MAX_BLUE: float = 1.0
const MIN_LOD: float = 0.0
const MAX_LOD: float = 3.5


# ----- INITIALIZATION AND PHYSICS -----

func _ready() -> void:
	if not PlayerManager.is_node_ready():
		await PlayerManager.ready
	
	current_lod_speed = PlayerManager.effects_increase_speed
	current_lod = blur_fisheye.get_shader_parameter("lod")
	target_lod = MIN_LOD

func _physics_process(delta: float) -> void:
	if PlayerManager.is_player_focusing():
		var new_lod = lerp(current_lod, target_lod, current_lod_speed * delta)
		if abs(new_lod - current_lod) > 0.001:
			new_lod = clamp(new_lod, MIN_LOD, MAX_LOD)
			current_lod = new_lod
			blur_fisheye.set_shader_parameter("lod", current_lod)
			current_blue = map_range(current_lod, MIN_LOD, MAX_LOD, MIN_BLUE, MAX_BLUE)
			blue_filter.modulate.a = current_blue
		else:
			new_lod = target_lod


# ----- EFFECTS -----

func set_effects(lod_value: float, lod_speed: float) -> void:
	if target_lod != lod_value:
		target_lod = lod_value
		current_lod_speed = lod_speed

# ----- SIGNALS -----




# ----- UTILS -----

func map_range(value: float, from_min: float, from_max: float, to_min: float, to_max: float) -> float:
	return (value - from_min) / (from_max - from_min) * (to_max - to_min) + to_min
