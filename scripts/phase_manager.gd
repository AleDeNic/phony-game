extends Node

enum Phase { SPLASH, PROLOGUE, MIDDLE, END, CREDITS }

@onready var phase_state: Phase = Phase.PROLOGUE

# ----- INITIALIZATION AND PHYSICS -----
# ...

# ----- HANDLING PHASE -----

func set_phase(new_phase: Phase) -> void:
	phase_state = new_phase
	print("Phase -> ", get_phase_value())

func get_phase() -> Phase:
	return phase_state
	
func get_phase_value():
	match phase_state:
		Phase.SPLASH:
			return "SPLASH"
		Phase.PROLOGUE:
			return "PROLOGUE"
		Phase.MIDDLE:
			return "MIDDLE"
		Phase.END:
			return "END"

# TODO: Funny.
func advance() -> void:
	match phase_state:
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


