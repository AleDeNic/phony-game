extends Node

var timeline_started: bool
var timeline_paused: bool

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
		if timeline_paused:
			Dialogic.paused = false
			timeline_paused = false
			Dialogic.Text.show_textbox()
			print("timeline resumed")
		else:
			Dialogic.paused = true
			timeline_paused = true
			Dialogic.Text.hide_textbox()
			await get_tree().create_timer(1).timeout
			#Dialogic.end_timeline()
			print("timeline paused")
	else:
		Dialogic.start(timeline)
		timeline_started = true
		Dialogic.Text.show_textbox()
		print("timeline started")

#func set_timeline_visibility() -> void:
	#if Dialogic.Text.is_textbox_visible():
		#Dialogic.Text.hide_textbox()
	#else:
		#Dialogic.Text.show_textbox()
