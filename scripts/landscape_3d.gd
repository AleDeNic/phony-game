extends Node3D

@onready var sky: ProceduralSkyMaterial = $WorldEnvironment.environment.sky.sky_material as ProceduralSkyMaterial
@onready var timer: Timer = $WorldEnvironment/Timer

var sky_speed: float = 30

var initial_top_color: Color = Color(0.0, 0.75, 0.95, 1.0)
var middle_top_color: Color = Color(0.5, 0.3, 0.95, 1.0)
var final_top_color: Color = Color(0.7, 0.75, 0.2, 1.0)

var transition_amount: float

var current_color: Color = initial_top_color

func _ready() -> void:
	timer.start()
	
	sky.sky_top_color = initial_top_color
	sky.sky_horizon_color = Color(1.0, 1.0, 1.0, 1.0)
	sky.ground_bottom_color = Color(0.2, 0.3, 1.0, 1.0)
	sky.ground_horizon_color = Color(1.0, 1.0, 1.0, 1.0)

func _process(delta: float) -> void:
	handle_sky()

func handle_sky() -> void:
	current_color = lerp_color(current_color, final_top_color, 0.02)
	sky.sky_top_color = current_color
	#timer.time_left

func lerp_color(color1: Color, color2: Color, t: float) -> Color:
	return Color(
		lerp(color1.r, color2.r, t),
		lerp(color1.g, color2.g, t),
		lerp(color1.b, color2.b, t),
		lerp(color1.a, color2.a, t)
	)

#func 
