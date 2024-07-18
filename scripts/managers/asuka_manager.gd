extends Node

enum PoseState {
	ARMS_CROSSED,
	OVER_TABLE
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
	set_pose_arms_crossed()
	set_expression_pleased()
	set_eyes_normal()


# ----- POSE SETTERS -----
func set_pose_state(new_pose: PoseState) -> void:
	pose_state = new_pose
	print("Asuka pose -> ", get_asuka_pose_value())


func set_pose_arms_crossed() -> void:
	set_pose_state(PoseState.ARMS_CROSSED)


func set_pose_over_table() -> void:
	set_pose_state(PoseState.OVER_TABLE)


# ----- POSE GETTERS -----
func get_asuka_pose() -> PoseState:
	return pose_state


func get_asuka_pose_value():
	match pose_state:
		PoseState.ARMS_CROSSED:
			return "ARMS_CROSSED"
		PoseState.OVER_TABLE:
			return "OVER_TABLE"


func are_asuka_arms_crossed() -> bool:
	return pose_state == PoseState.ARMS_CROSSED


func are_asuka_over_table() -> bool:
	return pose_state == PoseState.OVER_TABLE


# ----- EXPRESSION SETTERS -----
func set_expression_state(new_expression: ExpressionState) -> void:
	expression_state = new_expression
	print("Asuka -> ", get_asuka_expression_value())


func set_expression_pleased() -> void:
	set_expression_state(ExpressionState.PLEASED)


func set_expression_talking() -> void:
	set_expression_state(ExpressionState.TALKING)


func set_expression_upset() -> void:
	set_expression_state(ExpressionState.UPSET)


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


func set_eyes_normal() -> void:
	set_eyes_state(EyesState.NORMAL)


func set_eyes_closed() -> void:
	set_eyes_state(EyesState.CLOSED)


func set_eyes_lookaway() -> void:
	set_eyes_state(EyesState.LOOKAWAY)


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
