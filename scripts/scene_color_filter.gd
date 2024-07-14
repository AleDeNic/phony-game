extends Node2D

@onready var landscape_3d: Node3D = $"../Landscape/ParallaxBackground/ParallaxLayer/SubViewportContainer/SubViewport/Landscape3D"
@onready var color_filter: ShaderMaterial = $ColorOverlay/ColorFilter.material as ShaderMaterial

@export var color_amount: float = 0.6


# ----- INITIALIZE EVA 01 -----

func _ready() -> void:
	effects_coroutine()

func effects_coroutine() -> void:
	while true:
		await get_tree().create_timer(0.5).timeout
		update_color_filter(landscape_3d.current_sky)


# ----- COLOR OVERLAY -----

func update_color_filter(color_vector: Color) -> void:
	color_vector.a = color_amount
	color_filter.set_shader_parameter("overlay_color", color_vector)
