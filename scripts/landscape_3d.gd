extends Node3D

@onready var phase_manager: Node = get_node("/root/World/PhaseManager")

@onready var sky: ProceduralSkyMaterial = $WorldEnvironment.environment.sky.sky_material as ProceduralSkyMaterial
@onready var water: ShaderMaterial = $Water.mesh.material as ShaderMaterial
@onready var environment: Environment = $WorldEnvironment.environment

@export_group("Top")
@export var sky_prologue: Color = Color(0.0, 0.75, 0.95, 1.0)
@export var sky_middle: Color = Color(0.5, 0.1, 0.3, 1.0)
@export var sky_end: Color = Color(0.5, 0.3, 0.95, 1.0)

@export_group("Horizon")
@export var horizon_prologue: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var horizon_middle: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var horizon_end: Color = Color(1.0, 1.0, 1.0, 1.0)

@export_group("Ground")
@export var ground_prologue: Color = Color(0.2, 0.3, 1.0, 1.0)
@export var ground_middle: Color = Color(0.2, 0.3, 1.0, 1.0)
@export var ground_end: Color = Color(0.0, 0.0, 0.0, 1.0)

@export_group("Water")
@export var water_prologue: Color = Color(0.35, 0.45, 1.0, 1.0)
@export var water_middle: Color = Color(0.35, 0.45, 1.0, 1.0)
@export var water_end: Color = Color(0.1, 0.1, 0.1, 1.0)

@export_group("Speeds")
var color_speed: float = 0.002

var current_sky: Color
var current_horizon: Color
var current_ground: Color
var current_water: Color

var target_sky: Color
var target_horizon: Color
var target_ground: Color
var target_water: Color

func _ready() -> void:
	setup_colors()
	handle_target_colors()

func _process(delta: float) -> void:
	handle_sky_and_ground()
	handle_horizon()
	handle_water()

# ----- COLOR HANDLING -----
func handle_sky_and_ground() -> void:
	current_sky = lerp_color(current_sky, target_sky, color_speed)
	current_ground = lerp_color(current_ground, target_ground, color_speed)
	sky.sky_top_color = current_sky
	sky.ground_bottom_color = current_ground

func handle_horizon() -> void:
	current_horizon = lerp_color(current_horizon, target_horizon, color_speed)
	sky.sky_horizon_color = current_horizon
	sky.ground_horizon_color = current_horizon
	environment.fog_light_color = current_horizon

func handle_water() -> void:
	current_water = lerp_color(current_water, target_water, color_speed)
	water.set_shader_parameter("water_color", current_water)

func handle_target_colors() -> void:
	match phase_manager.get_phase():
		PhaseManager.Phase.PROLOGUE:
			change_target_colors(sky_prologue, horizon_prologue, ground_prologue, water_prologue)
		PhaseManager.Phase.MIDDLE:
			change_target_colors(sky_middle, horizon_middle, ground_middle, water_middle)
		PhaseManager.Phase.END:
			change_target_colors(sky_end, horizon_end, ground_end, water_end)

func change_target_colors(new_sky, new_horizon, new_ground, new_water): 
	target_sky = new_sky
	target_horizon = new_horizon
	target_ground = new_ground
	target_water = new_water

func setup_colors() -> void:
	current_sky = sky_prologue
	current_horizon = horizon_prologue
	current_ground = ground_prologue
	current_water = water_prologue

# ----- UTILS -----
func lerp_color(color1: Color, color2: Color, t: float) -> Color:
	return Color(
		lerp(color1.r, color2.r, t),
		lerp(color1.g, color2.g, t),
		lerp(color1.b, color2.b, t),
		lerp(color1.a, color2.a, t)
	)
