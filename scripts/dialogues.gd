extends Control

@onready var dialogues_animation: AnimationPlayer = $DialoguesAnimation

@export_group("Speeds")
@export var fade_in_speed = 3.0
@export var fade_out_speed = 8.0

var is_zooming_in: bool

func dialogues_visibility(is_it_visible) -> void:
	if is_it_visible:
		dialogues_animation.speed_scale = fade_in_speed
		dialogues_animation.play("visibility")
	else:
		dialogues_animation.speed_scale = fade_out_speed
		dialogues_animation.play_backwards("visibility")
