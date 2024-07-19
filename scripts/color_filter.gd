extends CanvasLayer

@onready var landscape_3d: Node3D = get_node("/root/World/Background/ParallaxBackground/ParallaxLayer/SubViewportContainer/SubViewport/Landscape3D")
@onready var color_overlay: ShaderMaterial = $ColorOverlay.material as ShaderMaterial

@export var color_amount: float = 0.6


# ----- INITIALIZE EVA 01 -----

func _ready() -> void:
	effects_coroutine()

func effects_coroutine() -> void:
	while true:
		update_color_filter(landscape_3d.current_sky)
		await get_tree().create_timer(0.5).timeout


# ----- COLOR OVERLAY -----

func update_color_filter(color_vector: Color) -> void:
	color_vector.a = color_amount
	color_overlay.set_shader_parameter("overlay_color", color_vector)
