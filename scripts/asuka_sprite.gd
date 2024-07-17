extends Node

@onready var asuka_02: Sprite2D = $Asuka02/Asuka02
@onready var expr_pleased_02: Sprite2D = $Asuka02/AsukaExpressions02/ExpPleased02
@onready var expr_talking_02: Sprite2D = $Asuka02/AsukaExpressions02/ExpTalking02
@onready var expr_upset_02: Sprite2D = $Asuka02/AsukaExpressions02/ExpUpset02
@onready var eyes_closed_02: Sprite2D = $Asuka02/AsukaEyes02/EyesClosed02
@onready var eyes_lookaway_02: Sprite2D = $Asuka02/AsukaEyes02/EyesLookaway02
@onready var eyes_normal_02: Sprite2D = $Asuka02/AsukaEyes02/EyesNormal02
@onready var asuka_03: Sprite2D = $Asuka03/Asuka03
@onready var expr_pleased_03: Sprite2D = $Asuka03/AsukaExpressions03/ExpPleased03
@onready var expr_talking_03: Sprite2D = $Asuka03/AsukaExpressions03/ExpTalking03
@onready var expr_upset_03: Sprite2D = $Asuka03/AsukaExpressions03/ExpUpset03
@onready var eyes_closed_03: Sprite2D = $Asuka03/AsukaEyes03/EyesClosed03
@onready var eyes_lookaway_03: Sprite2D = $Asuka03/AsukaEyes03/EyesLookaway03
@onready var eyes_normal_03: Sprite2D = $Asuka03/AsukaEyes03/EyesNormal03
@onready var asuka_arms_03: Sprite2D = $Asuka03/AsukaArms03

@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var player: CharacterBody2D = %Player

func _process(delta: float) -> void:
	update()

func update() -> void:
	if AsukaManager.are_asuka_arms_crossed():
		asuka_02.show()
		asuka_03.hide()
		asuka_arms_03.hide()
	elif AsukaManager.are_asuka_over_table():
		asuka_02.hide()
		asuka_03.show()
		asuka_arms_03.show()

	var expr_pleased: Sprite2D = expr_pleased_02 if AsukaManager.are_asuka_arms_crossed() else expr_pleased_03
	var expr_talking: Sprite2D = expr_talking_02 if AsukaManager.are_asuka_arms_crossed() else expr_talking_03
	var expr_upset: Sprite2D   = expr_upset_02 if AsukaManager.are_asuka_arms_crossed() else expr_upset_03

	expr_pleased.hide()
	expr_talking.hide()
	expr_upset.hide()

	if AsukaManager.is_expression_pleased():
		expr_pleased.show()
	elif AsukaManager.is_expression_talking():
		expr_talking.show()
	elif AsukaManager.is_expression_upset():
		expr_upset.show()

	var eyes_normal: Sprite2D   = eyes_normal_02 if AsukaManager.are_asuka_arms_crossed() else eyes_normal_03
	var eyes_closed: Sprite2D   = eyes_closed_02 if AsukaManager.are_asuka_arms_crossed() else eyes_closed_03
	var eyes_lookaway: Sprite2D = eyes_lookaway_02 if AsukaManager.are_asuka_arms_crossed() else eyes_lookaway_03

	eyes_normal.hide()
	eyes_closed.hide()
	eyes_lookaway.hide()

	if AsukaManager.are_eyes_normal():
		eyes_normal.show()
	elif AsukaManager.are_eyes_closed():
		eyes_closed.show()
	elif AsukaManager.are_eyes_lookaway():
		eyes_lookaway.show()
