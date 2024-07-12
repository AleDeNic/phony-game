extends Node

@export var phone_sickness_increase: int = 1
@export var rage_increase: int = 1

@export var phone_sickness_decrease: int = 30
@export var rage_decrease: int = 30

@export var max_phone_sickness: int = 300
@export var max_rage: int = 300

@export var phone_sickness_wait: int = 100

var phone_sickness: int = 0
var asuka_rage: int = 0


func _physics_process(delta: float) -> void:
	match PlayerManager.get_player_state():
		PlayerManager.PlayerState.FREE:
			increase_phone_sickness(delta)
			increase_asuka_rage(delta)
		PlayerManager.PlayerState.FOCUSED_PHONE:
			reset_phone_sickness(delta)
			increase_asuka_rage(delta)
		PlayerManager.PlayerState.FOCUSED_ASUKA:
			reset_asuka_rage(delta)
			increase_phone_sickness(delta)

	#print("Player phone_sickness: ", phone_sickness)
	#print("Asuka rage: ", asuka_rage)


# ----- INCREASE PANIC AND RAGE -----

func increase_phone_sickness(_delta) -> void:
	if phone_sickness < max_phone_sickness:
		phone_sickness += phone_sickness_increase

func increase_asuka_rage(_delta) -> void:
	if asuka_rage < max_rage:
		asuka_rage += rage_increase


# ----- RESET -----

func reset_phone_sickness(_delta) -> void:
	if phone_sickness > phone_sickness_decrease:
		phone_sickness -= phone_sickness_decrease
	else:
		phone_sickness = 0

func reset_asuka_rage(_delta) -> void:
	if asuka_rage > rage_decrease:
		asuka_rage -= rage_decrease
	else:
		asuka_rage = 0
