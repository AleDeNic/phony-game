extends Node

@export var panic_increase: float = 1.0
@export var rage_increase: float = 2.0

var player_panic: float
var asuka_rage: float

func _physics_process(delta: float) -> void:
	match PlayerManager.get_player_state():
		PlayerManager.PlayerState.FREE:
			handle_player_panic()
			handle_asuka_rage()
		PlayerManager.PlayerState.FOCUSED_ASUKA:
			pass
		PlayerManager.PlayerState.FOCUSED_PHONE:
			pass
	print("Player panic: ", player_panic)
	print("Asuka rage: ", asuka_rage)

func handle_player_panic() -> void:
	player_panic += panic_increase

func handle_asuka_rage() -> void:
	asuka_rage += rage_increase
