extends Node

# TODO: Investigate why the fuck this does have to be manual. Thanks
var timeline_started: bool

@export_group("Tasks values")
@export var phone_stress_heal: float = 0.3
@export var window_stress_increase: float = 0.1
@export var asuka_stress_increase: float = 0.2

@export_group("General values")
@export var max_stress: float = 30.0
@export var max_battery: float = 180.0

func _ready() -> void:
	timeline_started = false
	
func handle_timeline(timeline) -> void:
	if timeline_started:
		if Dialogic.paused:
			Dialogic.paused = false
			if Dialogic.Styles.get_layout_node():
				Dialogic.Styles.get_layout_node().show()
			print("timeline resumed")
		else:
			Dialogic.paused = true
			if Dialogic.Styles.get_layout_node():
				Dialogic.Styles.get_layout_node().hide()
			await get_tree().create_timer(1).timeout
			print("timeline paused")
	else:
		Dialogic.start(timeline)
		timeline_started = true
		
		if Dialogic.Styles.get_layout_node():
			Dialogic.Styles.get_layout_node().show()
		print("timeline started")
