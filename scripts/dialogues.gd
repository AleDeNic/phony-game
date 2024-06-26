extends Control

@onready var dialogues_animation: AnimationPlayer = $DialoguesAnimation

@export var visibility_speed = 3.0
@export var invisibility_speed = 8.0

var is_zooming_in: bool

func dialogues_visibility(is_visible) -> void:
	if is_visible:
		dialogues_animation.speed_scale = visibility_speed
		dialogues_animation.play("visibility")
	else:
		dialogues_animation.speed_scale = invisibility_speed
		dialogues_animation.play_backwards("visibility")
