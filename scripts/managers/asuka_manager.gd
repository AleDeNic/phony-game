extends Node

enum Pose {
	OVER_TABLE,
	ARMS_CROSSED
}
enum Expressions {
	PLEASED,
	TALKING,
	UPSET
}
enum Eyes {
	NORMAL,
	CLOSED,
	LOOKAWAY
}
@onready var pose_state: Pose
@onready var expression_state: Expressions
@onready var eye_state: Eyes


func _ready() -> void:
	set_state(Pose.OVER_TABLE, Expressions.PLEASED, Eyes.NORMAL)


func set_state(pose: Pose, expression: Expressions, eyes: Eyes) -> void:
	set_pose_state(pose)
	set_expression(expression)
	set_eyes(eyes)


## ----- POSE -----
func set_pose_state(new_pose: Pose) -> void:
	pose_state = new_pose
	print("Asuka pose -> ", get_pose_value())


func get_pose() -> Pose:
	return pose_state


func get_pose_value():
	match pose_state:
		Pose.ARMS_CROSSED:
			return "ARMS_CROSSED"
		Pose.OVER_TABLE:
			return "OVER_TABLE"
		_:
			return "UNKNOWN"


func is_over_table() -> bool:
	return pose_state == Pose.OVER_TABLE


func are_arms_crossed() -> bool:
	return pose_state == Pose.ARMS_CROSSED


## ----- EXPRESSION -----
func set_expression(new_expression: Expressions) -> void:
	expression_state = new_expression
	print("Asuka -> ", get_expression_value())


func get_expression() -> Expressions:
	return expression_state


func get_expression_value():
	match expression_state:
		Expressions.PLEASED:
			return "PLEASED"
		Expressions.TALKING:
			return "TALKING"
		Expressions.UPSET:
			return "UPSET"
		_:
			return "UNKNOWN"


func is_pleased() -> bool:
	return expression_state == Expressions.PLEASED


func is_talking() -> bool:
	return expression_state == Expressions.TALKING


func is_upset() -> bool:
	return expression_state == Expressions.UPSET


# ----- EYES -----
func set_eyes(new_state: Eyes) -> void:
	eye_state = new_state
	print("Eyes -> ", get_eyes_value())


func get_eyes() -> Eyes:
	return eye_state


func get_eyes_value():
	match eye_state:
		Eyes.NORMAL:
			return "NORMAL"
		Eyes.CLOSED:
			return "CLOSED"
		Eyes.LOOKAWAY:
			return "LOOKAWAY"
		_:
			return "UNKNOWN"


func are_eyes_normal() -> bool:
	return eye_state == Eyes.NORMAL


func are_eyes_closed() -> bool:
	return eye_state == Eyes.CLOSED


func are_eyes_lookaway() -> bool:
	return eye_state == Eyes.LOOKAWAY
