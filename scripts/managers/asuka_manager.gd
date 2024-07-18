extends Node

enum PoseState {
	OVER_TABLE,
	ARMS_CROSSED
}

enum ExpressionState {
	PLEASED,
	TALKING,
	UPSET
}

enum EyesState {
	NORMAL,
	CLOSED,
	LOOKAWAY
}

@onready var pose_state: PoseState
@onready var expression_state: ExpressionState
@onready var eye_state: EyesState

func _ready() -> void:
	set_asuka(PoseState.OVER_TABLE, ExpressionState.PLEASED, EyesState.NORMAL)

func set_asuka(pose: PoseState, expression: ExpressionState, eyes: EyesState) -> void:
	set_pose_state(pose)
	set_expression_state(expression)
	set_eyes_state(eyes)

# ----- POSE SETTERS -----
func set_pose_state(new_pose: PoseState) -> void:
	pose_state = new_pose
	print("Asuka pose -> ", get_asuka_pose_value())


# ----- POSE GETTERS -----
func get_asuka_pose() -> PoseState:
	return pose_state

func get_asuka_pose_value():
	match pose_state:
		PoseState.ARMS_CROSSED:
			return "ARMS_CROSSED"
		PoseState.OVER_TABLE:
			return "OVER_TABLE"

func is_asuka_pose_2() -> bool:
	return pose_state == PoseState.OVER_TABLE

func is_asuka_pose_3() -> bool:
	return pose_state == PoseState.ARMS_CROSSED


# ----- EXPRESSION SETTERS -----
func set_expression_state(new_expression: ExpressionState) -> void:
	expression_state = new_expression
	print("Asuka -> ", get_asuka_expression_value())


# ----- EXPRESSION GETTERS -----
func get_asuka_expression() -> ExpressionState:
	return expression_state

func get_asuka_expression_value():
	match expression_state:
		ExpressionState.PLEASED:
			return "PLEASED"
		ExpressionState.TALKING:
			return "TALKING"
		ExpressionState.UPSET:
			return "UPSET"


func is_expression_pleased() -> bool:
	return expression_state == ExpressionState.PLEASED

func is_expression_talking() -> bool:
	return expression_state == ExpressionState.TALKING

func is_expression_upset() -> bool:
	return expression_state == ExpressionState.UPSET


# ----- EYE STATE SETTERS -----
func set_eyes_state(new_state: EyesState) -> void:
	eye_state = new_state
	print("Eyes -> ", get_eyes_state_value())


# ----- EYE STATE GETTERS -----
func get_eyes_state() -> EyesState:
	return eye_state

func get_eyes_state_value():
	match eye_state:
		EyesState.NORMAL:
			return "NORMAL"
		EyesState.CLOSED:
			return "CLOSED"
		EyesState.LOOKAWAY:
			return "LOOKAWAY"


func are_eyes_normal() -> bool:
	return eye_state == EyesState.NORMAL

func are_eyes_closed() -> bool:
	return eye_state == EyesState.CLOSED

func are_eyes_lookaway() -> bool:
	return eye_state == EyesState.LOOKAWAY
