extends Control

@onready var game_manager: Node2D = %GameManager
@onready var stress_filter: ColorRect = $StressFilter
@onready var phone: Area2D = $"../Phone"
@onready var effects_animation: AnimationPlayer = $EffectsAnimation

var stress_level: float

func _ready() -> void:
	stress_level = 0

func _process(_delta: float) -> void:
	stress_filter.modulate.a = clamp(stress_level / game_manager.max_stress, 0.0, 1.0)

func start_effects(effects_speed) -> void:
	print("start effects")
	effects_animation.speed_scale = effects_speed
	if phone.is_zooming_in:
		effects_animation.play("blur")
	else:
		effects_animation.play_backwards("blur")

func _on_phone_timer_timeout() -> void:
	if stress_level > 0:
		stress_level -= game_manager.phone_stress_heal

func _on_asuka_timer_timeout() -> void:
	if stress_level < game_manager.max_stress:
		stress_level += game_manager.asuka_stress_increase
	else:
		print("LOOK AT YOUR PHONE")

func _on_window_timer_timeout() -> void:
	if stress_level < game_manager.max_stress:
		stress_level += game_manager.window_stress_increase
	else:
		print("LOOK AT YOUR PHONE")
