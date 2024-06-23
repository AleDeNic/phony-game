extends Node

@onready var brain_energy_bar: ProgressBar = $"../HUD/BrainEnergyBar"
@onready var attention_span_bar: ProgressBar = $"../HUD/AttentionSpanBar"
@onready var player: CharacterBody2D = %Player

var attention_span: float
var brain_energy: float

@export_group("Tasks values")
@export var phone_increase: float = 0.4
@export var window_decrease: float = 0.1
@export var asuka_decrease: float = 0.2

@export_group("General values")
@export var max_attention_span: float = 20.0
@export var max_brain_energy: int = 20
@export var multitasking_cost: int = 1

func _ready() -> void:
	attention_span = max_attention_span
	brain_energy = max_brain_energy
	brain_energy_bar.max_value = max_brain_energy
	attention_span_bar.max_value = max_attention_span

func _process(_delta: float) -> void:
	brain_energy_bar.value = brain_energy
	attention_span_bar.value = attention_span
	if brain_energy < 0:
		print("BRO IT'S GAME OVER")

func _on_phone_timer_timeout() -> void:
	if attention_span < max_attention_span:
		attention_span += phone_increase
	else:
		print("ATTENTION SPAN RESTORED")

func _on_asuka_timer_timeout() -> void:
	if attention_span > 0.0:
		attention_span -= asuka_decrease
	else:
		print("LOOK AT YOUR PHONE")

func _on_window_timer_timeout() -> void:
	if attention_span > 0.0:
		attention_span -= window_decrease
	else:
		print("LOOK AT YOUR PHONE")
