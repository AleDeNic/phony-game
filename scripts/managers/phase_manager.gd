extends Node

enum State { SPLASH, PROLOGUE, MIDDLE, END, CREDITS }
@onready var phase_state: State = State.PROLOGUE
@onready var points: int = 0
@onready var threshold: int = 15

var probability: float = 20.0


# ----- POINTS -----

func get_points() -> int:
	return points


func set_points(new_points: int) -> void:
	points = new_points
	print("Points -> ", points)


func add_points(new_points: int) -> void:
	points += new_points
	print("Points -> ", points)


func get_threshold() -> int:
	return threshold


func set_threshold(new_threshold: int) -> void:
	threshold = new_threshold
	print("Threshold -> ", threshold)


# TODO: This is a placeholder. Implement a proper check
func check_threshold() -> bool:
	match points:
		threshold:
			return true
		_:
			return false


# ----- PHASE -----
func set_phase(new_phase: State) -> void:
	phase_state = new_phase
	print("Phase -> ", get_phase_value())


func get_phase() -> State:
	return phase_state


func get_phase_value() -> String:
	match Phases.get_phase():
		Phases.is_splash():
			return "SPLASH"
		Phases.is_prologue():
			return "PROLOGUE"
		Phases.is_middle():
			return "MIDDLE"
		Phases.is_end():
			return "END"
		Phases.is_credits():
			return "CREDITS"
		_:
			return "UNKNOWN"


func set_splash() -> void:
	set_phase(Phases.State.SPLASH)


func set_prologue() -> void:
	set_phase(Phases.State.PROLOGUE)


func set_middle() -> void:
	set_phase(Phases.State.MIDDLE)


func set_end() -> void:
	set_phase(Phases.State.END)


func set_credits() -> void:
	set_phase(Phases.State.CREDITS)


func is_splash() -> bool:
	return phase_state == State.SPLASH


func is_prologue() -> bool:
	return phase_state == State.PROLOGUE


func is_middle() -> bool:
	return phase_state == State.MIDDLE


func is_end() -> bool:
	return phase_state == State.END


func is_credits() -> bool:
	return phase_state == State.CREDITS


# TODO: Funny. Very funny. But I'm not laughing.
func advance() -> void:
	match Phases.get_phase():
		Phases.is_splash():
			set_prologue()
			print("probability: ", probability)
		Phases.is_prologue():
			set_middle()
			probability += 20.0
			print("probability: ", probability)
		Phases.is_middle():
			set_end()
			probability += 20.0
			print("probability: ", probability)
		Phases.is_end():
			set_credits()
		Phases.is_credits():
			pass


# ----- UTILS -----

func can_dialogue_spawn() -> bool:
	if Story.angry_dialogue_active:
		print("Angry dialogue active, skipping spawn check")
		return false

	print("Probability: ", probability)
	var frankiePie: float = RandomNumberGenerator.new().randf_range(0.0, 100.0)

	print("frankiePie:fereacotr: _> refunct _> YouCanNot(new Anatichember) roooxane (toto) i lvoe tprogramign: -> ", frankiePie)
	return frankiePie <= probability
