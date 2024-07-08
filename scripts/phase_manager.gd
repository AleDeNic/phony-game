class_name PhaseManager
extends Node

enum Phase { SPLASH, PROLOGUE, MIDDLE, END, CREDITS }

var phase: Phase

func _ready() -> void:
	set_phase(Phase.PROLOGUE)

# ----- HANDLING PHASE -----
func set_phase(new_phase: Phase) -> void:
	phase = new_phase
	print_phase(phase)

func get_phase() -> Phase:
	return phase

func go_to_next_phase(phase: Phase) -> void:
	match phase:
		Phase.SPLASH:
			set_phase(Phase.PROLOGUE)
			pass
		Phase.PROLOGUE:
			set_phase(Phase.MIDDLE)
			pass
		Phase.MIDDLE:
			set_phase(Phase.END)
			pass
		Phase.END:
			set_phase(Phase.CREDITS)
			pass

# -----UTILS -----
func print_phase(phase):
	match phase:
		Phase.SPLASH:
			print("Phase: SPLASH")
		Phase.PROLOGUE:
			print("Phase: PROLOGUE")
		Phase.MIDDLE:
			print("Phase: MIDDLE")
		Phase.END:
			print("Phase: END")
