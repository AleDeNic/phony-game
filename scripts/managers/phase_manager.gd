extends Node

#region VARIABLES
enum State { SPLASH, PROLOGUE, MIDDLE, END, CREDITS }
@onready var phase_state: State = State.PROLOGUE
@onready var points: int = 0
@onready var threshold: int = 15

var probability: float = 20.0
#endregion

#region POINTS
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
#endregion


#region PHASE
func advance() -> void:
	if Phases.is_splash():
		set_prologue()
		print("probability: ", probability)
	elif Phases.is_prologue():
		set_middle()
		probability += 20.0
		print("probability: ", probability)
	elif Phases.is_middle():
		set_end()
		probability += 20.0
		print("probability: ", probability)
	elif Phases.is_end():
		set_credits()
	elif Phases.is_credits():
		pass


func set_phase(new_phase: State) -> void:
	phase_state = new_phase
	print("Phase -> ", get_phase_value())


func get_phase() -> State:
	return phase_state


func get_phase_value() -> String:
	if Phases.is_splash():
		return "SPLASH"
	elif Phases.is_prologue():
		return "PROLOGUE"
	elif Phases.is_middle():
		return "MIDDLE"
	elif Phases.is_end():
		return "END"
	elif Phases.is_credits():
		return "CREDITS"
	else:
		return "UNKNOWN"
#endregion


#region SETTERS
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
#endregion


#region IS
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
#endregion


#region UTILS
func can_dialogue_spawn() -> bool:
	print("Probability: ", probability)
	var frankiePie: float = RandomNumberGenerator.new().randf_range(0.0, 100.0)

	print("frankiePie:fereacotr: _> refunct _> YouCanNot(new Anatichember) roooxane (toto) i lvoe tprogramign: -> ", frankiePie)
	return frankiePie <= probability


func reset_all() -> void:
	set_points(0)
	set_threshold(15)
	set_phase(State.PROLOGUE)
	probability = 20.0
	print("Reset all -> ", get_phase_value())
#endregion
