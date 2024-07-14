extends CanvasLayer

@onready var landscape_3d: Node3D = $"../Landscape/ParallaxBackground/ParallaxLayer/SubViewportContainer/SubViewport/Landscape3D"
@onready var color_filter: ShaderMaterial = $ColorFilter.material as ShaderMaterial

var soft_light_color: Color
@export var color_amount: float = 0.6

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	handle_color_filter()
	change_color_filter(soft_light_color)

func change_color_filter(color_vector: Color) -> void:
	color_vector.a = color_amount
	color_filter.set_shader_parameter("overlay_color", color_vector)

func handle_color_filter() -> void:
	soft_light_color = landscape_3d.current_sky
