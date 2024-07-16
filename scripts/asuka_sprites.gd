extends Node2D

@onready var exp_pleased: Sprite2D = $AsukaExpressions/ExpPleased
@onready var exp_talking: Sprite2D = $AsukaExpressions/ExpTalking
@onready var exp_upset: Sprite2D = $AsukaExpressions/ExpUpset
@onready var eyes_closed: Sprite2D = $AsukaEyes/EyesClosed
@onready var eyes_lookaway: Sprite2D = $AsukaEyes/EyesLookaway
@onready var eyes_normal: Sprite2D = $AsukaEyes/EyesNormal

@export var asuka_pose: int = 0

func _ready() -> void:
	update_asuka_state()

func _process(_delta: float) -> void:
	update_asuka_state()

func update_asuka_state() -> void:
	var expression: Sprite2D
	var eyes: Sprite2D

	match AsukaManager.get_asuka_state():
		AsukaManager.AsukaState.PLEASED:
			expression = exp_pleased
		AsukaManager.AsukaState.TALKING:
			expression = exp_talking
		AsukaManager.AsukaState.UPSET:
			expression = exp_upset

	match AsukaManager.get_eye_state():
		AsukaManager.EyeState.NORMAL:
			eyes = eyes_normal
		AsukaManager.EyeState.CLOSED:
			eyes = eyes_closed
		AsukaManager.EyeState.LOOKAWAY:
			eyes = eyes_lookaway

	set_asuka_pose(expression, eyes)

# ----- SET POSE -----

func set_asuka_pose(eyes: Sprite2D, expression: Sprite2D) -> void:
	reset_asuka()
	eyes.visible = true
	expression.visible = true


# ----- RESET -----

func reset_asuka() -> void:
	exp_pleased.visible = false
	exp_talking.visible = false
	exp_upset.visible = false
	eyes_closed.visible = false
	eyes_lookaway.visible = false
	eyes_normal.visible = false

func reset_asuka_eyes() -> void:
	eyes_closed.visible = false
	eyes_lookaway.visible = false
	eyes_normal.visible = false

func reset_asuka_expression() -> void:
	exp_pleased.visible = false
	exp_talking.visible = false
	exp_upset.visible = false
