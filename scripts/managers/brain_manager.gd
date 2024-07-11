extends Node

var panic: float
var rage_level: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	pass

func handle_panic() -> void:
	pass

func _on_phone_timer_timeout() -> void:
	print("phone timer")
	if panic > 0:
		panic -= PlayerManager.phone_stress_heal

func _on_asuka_timer_timeout() -> void:
	print("asuka timer")
	if rage_level < PlayerManager.max_stress:
		rage_level += PlayerManager.asuka_stress_increase
