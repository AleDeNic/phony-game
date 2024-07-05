extends Control

@onready var game_manager: Node2D = %GameManager
@onready var stress_filter: ColorRect = $StressFilter
@onready var phone: Area2D = $"../Phone"
@onready var effects_animation: AnimationPlayer = $EffectsAnimation
@onready var player: CharacterBody2D = %Player
@onready var blur_fisheye: ShaderMaterial = get_node("BlurFisheye").material as ShaderMaterial
@onready var blue_filter: ColorRect = $BlueFilter

var stress_level: float = 0.0
var target_lod: float = 3.5

var current_lod: float = 0.0
var current_lod_speed: float = 0.0

var current_blue: float = 0.0
const min_blue: float = 0.0
const max_blue: float = 1.0

const min_lod: float = 0.0
const max_lod: float = 3.5

func _ready() -> void:
	current_lod_speed = phone.effects_increase_speed
	current_lod = blur_fisheye.get_shader_parameter("lod")
	target_lod = min_lod

func _process(delta: float) -> void:
	if player.state in ["phone_zooming_in", "phone_zooming_out", "phone", "free"]:
		var new_lod = lerp(current_lod, target_lod, current_lod_speed * delta)
		if abs(new_lod - current_lod) > 0.001:
			new_lod = clamp(new_lod, min_lod, max_lod)
			current_lod = new_lod
			blur_fisheye.set_shader_parameter("lod", current_lod)
			current_blue = map_range(current_lod, min_lod, max_lod, min_blue, max_blue)
			blue_filter.modulate.a = current_blue

func set_effects(lod_value: float, lod_speed: float) -> void:
	if target_lod != lod_value:
		target_lod = lod_value
		current_lod_speed = lod_speed

func map_range(value: float, from_min: float, from_max: float, to_min: float, to_max: float) -> float:
	return (value - from_min) / (from_max - from_min) * (to_max - to_min) + to_min

func _on_phone_timer_timeout() -> void:
	if stress_level > 0:
		stress_level -= game_manager.phone_stress_heal

func _on_asuka_timer_timeout() -> void:
	if stress_level < game_manager.max_stress:
		stress_level += game_manager.asuka_stress_increase

func _on_window_timer_timeout() -> void:
	if stress_level < game_manager.max_stress:
		stress_level += game_manager.window_stress_increase
