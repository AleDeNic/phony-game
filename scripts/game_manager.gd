extends Node

@onready var battery_bar: ProgressBar = $"../Phone/PhoneScreen/Battery/BatteryMargin/BateryVBox/BatteryBar"
@onready var timer: Timer = $GameTimer
@onready var stress_filter: ColorRect = $"../Effects/StressFilter"

var stress_level: float

@export_group("Tasks values")
@export var phone_stress_heal: float = 0.3
@export var window_stress_increase: float = 0.1
@export var asuka_stress_increase: float = 0.2

@export_group("General values")
@export var max_stress: float = 30.0
@export var max_battery: float = 180.0

func _ready() -> void:	
	stress_level = 0
	start_timeline("asuka")
	timer.wait_time = max_battery
	battery_bar.max_value = max_battery
	timer.start()
	timer.paused = true

func _process(_delta: float) -> void:
	battery_bar.value = timer.time_left
	stress_filter.modulate.a = clamp(stress_level / max_stress, 0.0, 1.0)

func _on_phone_timer_timeout() -> void:
	if stress_level > 0:
		stress_level -= phone_stress_heal

func _on_asuka_timer_timeout() -> void:
	if stress_level < max_stress:
		stress_level += asuka_stress_increase
	else:
		print("LOOK AT YOUR PHONE")

func _on_window_timer_timeout() -> void:
	if stress_level < max_stress:
		stress_level += window_stress_increase
	else:
		print("LOOK AT YOUR PHONE")

func _on_timer_timeout() -> void:
	print("GAME OVERRRRRR")
	
func start_timeline(timeline) -> void:
	Dialogic.start(timeline)

func set_timeline_visibility() -> void:
	if Dialogic.Text.is_textbox_visible():
		Dialogic.Text.hide_textbox()
	else:
		Dialogic.Text.show_textbox()
