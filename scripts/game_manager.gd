extends Node

@onready var brain_energy_bar: ProgressBar = $"../HUD/BrainEnergyBar"
@onready var attention_span_bar: ProgressBar = $"../HUD/AttentionSpanBar"

var attention_span: float
var brain_energy

@export_group("Tasks values")
@export var phone_increase: float = 0.4
@export var window_decrease: float = 0.1
@export var asuka_decrease: float = 0.2

@export_group("General values")
@export var max_attention_span: float = 20.0
@export var max_brain_energy = 20
@export var multitasking_cost = 1

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
	if attention_span < 0:
		print("LOOK AT YOUR PHONE")
