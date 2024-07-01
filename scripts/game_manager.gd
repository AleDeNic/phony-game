extends Node

# TODO: Investigate why the fuck this does have to be manual. Thanks

@export_group("Tasks values")
@export var phone_stress_heal: float = 0.3
@export var window_stress_increase: float = 0.1
@export var asuka_stress_increase: float = 0.2

@export_group("General values")
@export var max_stress: float = 30.0
@export var max_battery: float = 180.0

var timelines: Dictionary = {"asuka": false, "window": false}

var object: Object = {Object: {started: false}}

func _ready() -> void:
	for timeline in timelines:
		timelines[timeline] = false
	print("Timelines initialized: ", timelines)
	
func handle_timeline(timeline: String, reset: bool = false) -> void:
	print("Handling timeline: ", timeline)
	if timelines.has(timeline):
		if reset:
			timelines[timeline] = false
			if Dialogic.Styles.get_layout_node():
				Dialogic.Styles.get_layout_node().hide()
			print(timeline + " timeline reset | Timelines: ", timelines)
		elif timelines[timeline]:
			if Dialogic.paused:
				Dialogic.paused = false
				if Dialogic.Styles.get_layout_node():
					Dialogic.Styles.get_layout_node().show()
					print(timeline + " timeline resumed | Timelines: ", timelines)
			else:
				Dialogic.paused = true
				if Dialogic.Styles.get_layout_node():
					Dialogic.Styles.get_layout_node().hide()
					print(timeline + " timeline paused | Timelines: ", timelines)
		else:
			Dialogic.start(timeline)
			Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
			timelines[timeline] = true
			if Dialogic.Styles.get_layout_node():
				Dialogic.Styles.get_layout_node().show()
			print(timeline + " timeline started | Timelines: ", timelines)
	else:
		print("Timeline ", timeline, " does not exist in timelines dictionary.")
