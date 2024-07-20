extends HSlider

@onready var player: CharacterBody2D = get_node("/root/World/Player")

func _ready() -> void:
	value_changed.connect(_on_value_changed)
	value = player.mouse_sensitivity

func _on_value_changed(sensitivity_value: float) -> void:
	player.mouse_sensitivity = sensitivity_value
	print("Sensitivity changed to: ", player.mouse_sensitivity)
