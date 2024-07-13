#extends Node
#
#@export_group("Phone sickness")
#@export var phone_sickness_increase: int = 1
#@export var phone_sickness_decrease: int = 30
#@export var max_phone_sickness: int = 300
#@export var phone_sickness_wait: int = 100
#
#var phone_sickness: int = 0
#
#
#func _physics_process(delta: float) -> void:
	#if PlayerManager.is_player_focused_phone():
		#reset_phone_sickness()
	#elif !NotificationsManager.are_notifications_cleared:
		#increase_phone_sickness()
#
	##print("Player phone_sickness: ", phone_sickness)
#
#
## ----- INCREASE PANIC AND RAGE -----
#
#func increase_phone_sickness() -> void:
	#if phone_sickness < max_phone_sickness:
		#phone_sickness += phone_sickness_increase
#
#
## ----- RESET -----
#
#func reset_phone_sickness() -> void:
	#if phone_sickness > phone_sickness_decrease:
		#phone_sickness -= phone_sickness_decrease
	#else:
		#phone_sickness = 0
