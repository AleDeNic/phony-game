extends CanvasLayer

@onready var panic_filter: ShaderMaterial = $PanicCanvas/PanicFilter.material as ShaderMaterial

func _physics_process(delta: float) -> void:
	handle_panic_filter()

func handle_panic_filter() -> void:
	# effect increases with player panic
	var panic_lod
	panic_lod = map_range(BrainManager.player_panic, 0, 300, 0, 3)
	panic_filter.set_shader_parameter("lod", panic_lod)

# ----- UTILS -----

func map_range(value: float, from_min: float, from_max: float, to_min: float, to_max: float) -> float:
	return (value - from_min) / (from_max - from_min) * (to_max - to_min) + to_min
