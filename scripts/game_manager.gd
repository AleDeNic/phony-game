extends Node

@export_group("Tasks values")
@export var phone_stress_heal: float = 0.3
@export var window_stress_increase: float = 0.1
@export var asuka_stress_increase: float = 0.2

@export_group("General values")
@export var max_stress: float = 30.0
@export var max_battery: float = 180.0

var asuka_timeline: Timeline
var window_timeline: Timeline

func _ready() -> void:
	asuka_timeline = Timeline.new("asuka")
	window_timeline = Timeline.new("window")
	print("Timelines initialized: ", asuka_timeline.name, ", ", window_timeline.name)

func handle_timeline(timeline_name: String, reset: bool = false) -> void:
	var timeline: Timeline = null
	if timeline_name == "asuka":
		timeline = asuka_timeline
	elif timeline_name == "window":
		timeline = window_timeline

	if timeline:
		if reset:
			timeline.reset()
			print(timeline_name + " timeline reset")
		else:
			if timeline.started and not timeline.ended:
				if Dialogic.paused:
					timeline.resume()
					print(timeline_name + " timeline resumed")
				else:
					timeline.pause()
					print(timeline_name + " timeline paused")
			else:
				if asuka_timeline.started:
					asuka_timeline.save_state()
				if window_timeline.started:
					window_timeline.save_state()
				timeline.restore_state()
				print(timeline_name + " timeline started/restored")
	else:
		print("Timeline ", timeline_name, " does not exist.")
