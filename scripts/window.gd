extends Area2D

@export var dialogue_resource: Resource = load("res://dialogues/window.dialogue")
@export var dialogue_start: String = "window_intro"

@onready var camera: Camera2D = $"../Player/Camera2D"


# ----- STATE MANAGEMENT -----

func _on_area_entered(_area: Area2D) -> void:
	PhaseManager.advance()
