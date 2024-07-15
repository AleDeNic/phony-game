extends Node2D

@onready var exp_pleased: Sprite2D = $AsukaExpressions/ExpPleased
@onready var exp_talking: Sprite2D = $AsukaExpressions/ExpTalking
@onready var exp_upset: Sprite2D = $AsukaExpressions/ExpUpset
@onready var eyes_closed: Sprite2D = $AsukaEyes/EyesClosed
@onready var eyes_lookaway: Sprite2D = $AsukaEyes/EyesLookaway
@onready var eyes_normal: Sprite2D = $AsukaEyes/EyesNormal

@export var asuka_pose: int = 0

func _ready() -> void:
	set_asuka_upset_eyes_normal()


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


# ----- PLEASED -----

func set_asuka_pleased_eyes_closed() -> void:
	set_asuka_pose(exp_pleased, eyes_closed)

func set_asuka_pleased_eyes_lookaway() -> void:
	set_asuka_pose(exp_pleased, eyes_lookaway)

func set_asuka_pleased_eyes_normal() -> void:
	set_asuka_pose(exp_pleased, eyes_normal)


# ----- TALKING -----

func set_asuka_talking_eyes_closed() -> void:
	set_asuka_pose(exp_talking, eyes_closed)

func set_asuka_talking_eyes_lookaway() -> void:
	set_asuka_pose(exp_talking, eyes_lookaway)

func set_asuka_talking_eyes_normal() -> void:
	set_asuka_pose(exp_talking, eyes_normal)


# ----- UPSET -----

func set_asuka_upset_eyes_closed() -> void:
	set_asuka_pose(exp_upset, eyes_closed)

func set_asuka_upset_eyes_lookaway() -> void:
	set_asuka_pose(exp_upset, eyes_lookaway)

func set_asuka_upset_eyes_normal() -> void:
	set_asuka_pose(exp_upset, eyes_normal)


# ----- EYES -----

func set_eyes_normal() -> void:
	reset_asuka_eyes()
	eyes_normal.visible = true

func set_eyes_lookaway() -> void:
	reset_asuka_eyes()
	eyes_lookaway.visible = true

func set_eyes_closed() -> void:
	reset_asuka_eyes()
	eyes_closed.visible = true
