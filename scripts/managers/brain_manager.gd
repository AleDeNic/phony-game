extends Node

@export var panic_increase: int = 1
@export var rage_increase: int = 1

@export var panic_decrease: int = 30
@export var rage_decrease: int = 30

@export var max_panic: int = 300
@export var max_rage: int = 300

var player_panic: int = 0
var asuka_rage: int = 0


func _physics_process(delta: float) -> void:
	match PlayerManager.get_player_state():
		PlayerManager.PlayerState.FREE:
			increase_player_panic(delta)
			increase_asuka_rage(delta)
		PlayerManager.PlayerState.FOCUSED_PHONE:
			reset_player_panic(delta)
			increase_asuka_rage(delta)
		PlayerManager.PlayerState.FOCUSED_ASUKA:
			reset_asuka_rage(delta)
			increase_player_panic(delta)

	#print("Player panic: ", player_panic)
	#print("Asuka rage: ", asuka_rage)


# ----- INCREASE PANIC AND RAGE -----

func increase_player_panic(delta) -> void:
	if player_panic < max_panic:
		player_panic += panic_increase

func increase_asuka_rage(delta) -> void:
	if asuka_rage < max_rage:
		asuka_rage += rage_increase


# ----- RESET -----

func reset_player_panic(delta) -> void:
	if player_panic > panic_decrease:
		player_panic -= panic_decrease
	else:
		player_panic = 0

func reset_asuka_rage(delta) -> void:
	if asuka_rage > rage_decrease:
		asuka_rage -= rage_decrease
	else:
		asuka_rage = 0
