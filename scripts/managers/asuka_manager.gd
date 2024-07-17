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


enum AsukaPose {
	ARMS_CROSSED,
	OVER_TABLE
}

enum AsukaExpression {
	PLEASED,
	TALKING,
	UPSET
}

enum EyeState {
	NORMAL,
	CLOSED,
	LOOKAWAY
}

@onready var asuka_pose: AsukaPose = AsukaPose.OVER_TABLE
@onready var asuka_expression: AsukaExpression = AsukaExpression.PLEASED
@onready var eye_state: EyeState = EyeState.NORMAL

func _ready() -> void:
	asuka_state_coroutine()

func asuka_state_coroutine() -> void:
	while true:
		await get_tree().create_timer(0.2).timeout
		update_asuka_state()

func update_asuka_state() -> void:
	var pose: Sprite2D
	var expression: Sprite2D
	var eyes: Sprite2D

	match AsukaManager.get_asuka_pose():
		AsukaManager.AsukaPose.ARMS_CROSSED:
			pose = asuka_02
			
			match AsukaManager.get_asuka_expression():
				AsukaManager.AsukaExpression.PLEASED:
					expression = expr_pleased_02
				AsukaManager.AsukaExpression.TALKING:
					expression = expr_talking_02
				AsukaManager.AsukaExpression.UPSET:
					expression = expr_upset_02
					
			match AsukaManager.get_eyes_state():
				AsukaManager.EyeState.NORMAL:
					eyes = eyes_normal_02
				AsukaManager.EyeState.CLOSED:
					eyes = eyes_closed_02
				AsukaManager.EyeState.LOOKAWAY:
					eyes = eyes_lookaway_02
					
		AsukaManager.AsukaPose.OVER_TABLE:
			pose = asuka_03
			
			match AsukaManager.get_asuka_expression():
				AsukaManager.AsukaExpression.PLEASED:
					expression = expr_pleased_03
				AsukaManager.AsukaExpression.TALKING:
					expression = expr_talking_03
				AsukaManager.AsukaExpression.UPSET:
					expression = expr_upset_03
					
			match AsukaManager.get_eyes_state():
				AsukaManager.EyeState.NORMAL:
					eyes = eyes_normal_03
				AsukaManager.EyeState.CLOSED:
					eyes = eyes_closed_03
				AsukaManager.EyeState.LOOKAWAY:
					eyes = eyes_lookaway_03

	set_asuka(pose, expression, eyes)


# ----- SET POSE -----

func set_asuka(pose: Sprite2D, eyes: Sprite2D, expression: Sprite2D) -> void:
	reset_asuka()
	pose.visible = true
	eyes.visible = true
	expression.visible = true


# ----- RESET -----

func reset_asuka() -> void:
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

func reset_asuka_eyes() -> void:
	eyes_closed_03.visible = false
	eyes_lookaway_03.visible = false
	eyes_normal_03.visible = false

func reset_asuka_expression() -> void:
	expr_pleased_03.visible = false
	expr_talking_03.visible = false
	expr_upset_03.visible = false


# ----- EXPRESSION SETTERS -----

func set_asuka_pose(new_pose: AsukaPose) -> void:
	asuka_pose = new_pose
	print("Asuka pose -> ", get_asuka_pose_value())
	
func set_asuka_arms_crossed() -> void:
	set_asuka_pose(AsukaPose.ARMS_CROSSED)
	
func set_asuka_over_table() -> void:
	set_asuka_pose(AsukaPose.OVER_TABLE)


# ----- ASUKA POSE GETTERS -----

func get_asuka_pose() -> AsukaExpression:
	return asuka_expression
	
func get_asuka_pose_value():
	match asuka_pose:
		AsukaPose.ARMS_CROSSED:
			return "ARMS_CROSSED"
		AsukaPose.OVER_TABLE:
			return "OVER_TABLE"

func is_asuka_arms_crossed() -> bool:
		return asuka_pose == AsukaPose.ARMS_CROSSED
	
func is_asuka_over_table() -> bool:
		return asuka_pose == AsukaPose.OVER_TABLE


# ----- EXPRESSION SETTERS -----

func set_asuka_expression(new_expression: AsukaExpression) -> void:
	asuka_expression = new_expression
	print("Asuka -> ", get_asuka_expression_value())
	
func set_asuka_pleased() -> void:
	set_asuka_expression(AsukaExpression.PLEASED)
	
func set_asuka_talking() -> void:
	set_asuka_expression(AsukaExpression.TALKING)
	
func set_asuka_upset() -> void:
	set_asuka_expression(AsukaExpression.UPSET)


# ----- ASUKA EXPRESSION GETTERS -----

func get_asuka_expression() -> AsukaExpression:
	return asuka_expression
	
func get_asuka_expression_value():
	match asuka_expression:
		AsukaExpression.PLEASED:
			return "PLEASED"
		AsukaExpression.TALKING:
			return "TALKING"
		AsukaExpression.UPSET:
			return "UPSET"

func is_asuka_pleased() -> bool:
		return asuka_expression == AsukaExpression.PLEASED
	
func is_asuka_talking() -> bool:
		return asuka_expression == AsukaExpression.TALKING
	
func is_asuka_upset() -> bool:
		return asuka_expression == AsukaExpression.UPSET


# ----- EYE STATE SETTERS -----

func set_eyes_state(new_state: EyeState) -> void:
	eye_state = new_state
	print("Eyes -> ", get_eyes_state_value())
	
func set_eyes_normal() -> void:
	set_eyes_state(EyeState.NORMAL)
	
func set_eyes_closed() -> void:
	set_eyes_state(EyeState.CLOSED)
	
func set_eyes_lookaway() -> void:
	set_eyes_state(EyeState.LOOKAWAY)


# ----- EYE STATE GETTERS -----

func get_eyes_state() -> EyeState:
	return eye_state
	
func get_eyes_state_value():
	match eye_state:
		EyeState.NORMAL:
			return "NORMAL"
		EyeState.CLOSED:
			return "CLOSED"
		EyeState.LOOKAWAY:
			return "LOOKAWAY"

func are_eyes_normal() -> bool:
	return eye_state == EyeState.NORMAL
	
func are_eyes_closed() -> bool:
	return eye_state == EyeState.CLOSED
	
func are_eyes_lookaway() -> bool:
	return eye_state == EyeState.LOOKAWAY
