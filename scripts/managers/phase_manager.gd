extends Node

enum Phase { SPLASH, PROLOGUE, MIDDLE, END, CREDITS }

@onready var phase_state: Phase = Phase.PROLOGUE
@onready var points: int = 0
@onready var threshold: int = 15

var probability: float = 20.0

# ----- INITIALIZATION AND PHYSICS -----
# ----- HANDLING PHASE -----
func get_points() -> int:
	return points
	
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

# TODO: Funny. Very funny. But I'm not laughing.
func advance() -> void:
	match phase_state:
		Phase.SPLASH:
			set_phase(Phase.PROLOGUE)
			print("probability: ", probability)
		Phase.PROLOGUE:
			set_phase(Phase.MIDDLE)
			probability += 20.0
			print("probability: ", probability)
		Phase.MIDDLE:
			set_phase(Phase.END)
			probability += 20.0
			print("probability: ", probability)
		Phase.END:
			set_phase(Phase.CREDITS)

# ----- UTILS -----

func can_dialogue_spawn() -> bool:
	print("Probability: ", probability)
	var frankiePie: float = RandomNumberGenerator.new().randf_range(0.0, 100.0)
	
	print("frankiePie:fereacotr: _> refunct _> YouCanNot(new Anatichember) roooxane (toto) i lvoe tprogramign: -> ", frankiePie)
	return frankiePie <= probability
