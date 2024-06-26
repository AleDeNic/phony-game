extends Node

@onready var stress_bar: ProgressBar = $"../Phone/PhoneScreen/Bars/BarsMargin/BarsVBox/TimeBar"
@onready var time_bar: ProgressBar = $"../Phone/PhoneScreen/Bars/BarsMargin/BarsVBox/StressBar"
@onready var timer: Timer = $GameTimer

# start, pause, play
var game_state: String = "start"

var stress_level: float

@export_group("Tasks values")
@export var phone_stress_heal: float = 0.2
@export var window_stress_increase: float = 0.1
@export var asuka_stress_increase: float = 0.2

@export_group("General values")
@export var max_stress: float = 20.0
@export var max_battery: float = 180

func _ready() -> void:
	stress_level = 0
	timer.wait_time = max_battery
	time_bar.max_value = max_battery
	stress_bar.max_value = max_stress
	timer.start()
	timer.paused = true

func _process(_delta: float) -> void:
	time_bar.value = timer.time_left
	stress_bar.value = stress_level

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
