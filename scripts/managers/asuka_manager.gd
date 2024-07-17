extends Node

@onready var asuka_02: Sprite2D = get_node("/root/World/Landscape/TrainInterior/Asuka02/Asuka02")
@onready var expr_pleased_02: Sprite2D = get_node("/root/World/Landscape/TrainInterior/Asuka02/AsukaExpressions02/ExpPleased02")
@onready var expr_talking_02: Sprite2D = get_node("/root/World/Landscape/TrainInterior/Asuka02/AsukaExpressions02/ExpTalking02")
@onready var expr_upset_02: Sprite2D = get_node("/root/World/Landscape/TrainInterior/Asuka02/AsukaExpressions02/ExpUpset02")
@onready var eyes_closed_02: Sprite2D = get_node("/root/World/Landscape/TrainInterior/Asuka02/AsukaEyes02/EyesClosed02")
@onready var eyes_lookaway_02: Sprite2D = get_node("/root/World/Landscape/TrainInterior/Asuka02/AsukaEyes02/EyesLookaway02")
@onready var eyes_normal_02: Sprite2D = get_node("/root/World/Landscape/TrainInterior/Asuka02/AsukaEyes02/EyesNormal02")

@onready var asuka_03: Sprite2D = get_node("/root/World/Landscape/TrainInterior/Asuka03/Asuka03")
@onready var expr_pleased_03: Sprite2D = get_node("/root/World/Landscape/TrainInterior/Asuka03/AsukaExpressions03/ExprPleased03")
@onready var expr_talking_03: Sprite2D = get_node("/root/World/Landscape/TrainInterior/Asuka03/AsukaExpressions03/ExprTalking03")
@onready var expr_upset_03: Sprite2D = get_node("/root/World/Landscape/TrainInterior/Asuka03/AsukaExpressions03/ExprUpset03")
@onready var eyes_closed_03: Sprite2D = get_node("/root/World/Landscape/TrainInterior/Asuka03/AsukaEyes03/EyesClosed03")
@onready var eyes_lookaway_03: Sprite2D = get_node("/root/World/Landscape/TrainInterior/Asuka03/AsukaEyes03/EyesLookaway03")
@onready var eyes_normal_03: Sprite2D = get_node("/root/World/Landscape/TrainInterior/Asuka03/AsukaEyes03/EyesNormal03")
@onready var asuka_arms_03: Sprite2D = get_node("/root/World/Landscape/TrainInterior/Asuka03/AsukaArms03")


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
	set_pose_state(AsukaManager.PoseState.OVER_TABLE)
	set_expression_state(AsukaManager.ExpressionState.UPSET)
	set_eyes_state(AsukaManager.EyesState.LOOKAWAY)
	
	asuka_state_coroutine()

func asuka_state_coroutine() -> void:
	while true:
		update_asuka_sprites()
		await get_tree().create_timer(0.2).timeout

func update_asuka_sprites() -> void:
	var pose: Sprite2D
	var expression: Sprite2D
	var eyes: Sprite2D

	match AsukaManager.get_asuka_pose():
		AsukaManager.PoseState.ARMS_CROSSED:
			pose = asuka_02
			
			match AsukaManager.get_asuka_expression():
				AsukaManager.ExpressionState.PLEASED:
					expression = expr_pleased_02
				AsukaManager.ExpressionState.TALKING:
					expression = expr_talking_02
				AsukaManager.ExpressionState.UPSET:
					expression = expr_upset_02
					
			match AsukaManager.get_eyes_state():
				AsukaManager.EyesState.NORMAL:
					eyes = eyes_normal_02
				AsukaManager.EyesState.CLOSED:
					eyes = eyes_closed_02
				AsukaManager.EyesState.LOOKAWAY:
					eyes = eyes_lookaway_02
					
		AsukaManager.PoseState.OVER_TABLE:
			pose = asuka_03
			
			match AsukaManager.get_asuka_expression():
				AsukaManager.ExpressionState.PLEASED:
					expression = expr_pleased_03
				AsukaManager.ExpressionState.TALKING:
					expression = expr_talking_03
				AsukaManager.ExpressionState.UPSET:
					expression = expr_upset_03
					
			match AsukaManager.get_eyes_state():
				AsukaManager.EyesState.NORMAL:
					eyes = eyes_normal_03
				AsukaManager.EyesState.CLOSED:
					eyes = eyes_closed_03
				AsukaManager.EyesState.LOOKAWAY:
					eyes = eyes_lookaway_03

	set_asuka(pose, expression, eyes)


# ----- SET POSE -----

func set_asuka(pose: Sprite2D, expression: Sprite2D, eyes: Sprite2D) -> void:
	reset_asuka()
	pose.visible = true
	expression.visible = true
	eyes.visible = true


# ----- RESET -----

func reset_asuka() -> void:
	asuka_02.visible = false
	asuka_03.visible = false
	
	expr_pleased_02.visible = false
	expr_talking_02.visible = false
	expr_upset_02.visible = false
	eyes_closed_02.visible = false
	eyes_lookaway_02.visible = false
	eyes_normal_02.visible = false
	
	expr_pleased_03.visible = false
	expr_talking_03.visible = false
	expr_upset_03.visible = false
	eyes_closed_03.visible = false
	eyes_lookaway_03.visible = false
	eyes_normal_03.visible = false
	asuka_arms_03.visible = false


# ----- EXPRESSION SETTERS -----

func set_pose_state(new_pose: PoseState) -> void:
	pose_state = new_pose
	print("Asuka pose -> ", get_asuka_pose_value())
	
func set_asuka_arms_crossed() -> void:
	set_pose_state(PoseState.ARMS_CROSSED)
	
func set_asuka_over_table() -> void:
	set_pose_state(PoseState.OVER_TABLE)


# ----- ASUKA POSE GETTERS -----

func get_asuka_pose() -> ExpressionState:
	return expression_state
	
func get_asuka_pose_value():
	match pose_state:
		PoseState.ARMS_CROSSED:
			return "ARMS_CROSSED"
		PoseState.OVER_TABLE:
			return "OVER_TABLE"

func is_asuka_arms_crossed() -> bool:
		return pose_state == PoseState.ARMS_CROSSED
	
func is_asuka_over_table() -> bool:
		return pose_state == PoseState.OVER_TABLE


# ----- EXPRESSION SETTERS -----

func set_expression_state(new_expression: ExpressionState) -> void:
	expression_state = new_expression
	print("Asuka -> ", get_asuka_expression_value())
	
func set_asuka_pleased() -> void:
	set_expression_state(ExpressionState.PLEASED)
	
func set_asuka_talking() -> void:
	set_expression_state(ExpressionState.TALKING)
	
func set_asuka_upset() -> void:
	set_expression_state(ExpressionState.UPSET)


# ----- ASUKA EXPRESSION GETTERS -----

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

func is_asuka_pleased() -> bool:
		return expression_state == ExpressionState.PLEASED
	
func is_asuka_talking() -> bool:
		return expression_state == ExpressionState.TALKING
	
func is_asuka_upset() -> bool:
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
