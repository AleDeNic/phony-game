@tool

extends Node2D

@onready var exp_pleased: Sprite2D = $AsukaExpressions/ExpPleased
@onready var exp_talking: Sprite2D = $AsukaExpressions/ExpTalking
@onready var exp_upset: Sprite2D = $AsukaExpressions/ExpUpset
@onready var eyes_closed: Sprite2D = $AsukaEyes/EyesClosed
@onready var eyes_lookaway: Sprite2D = $AsukaEyes/EyesLookaway
@onready var eyes_normal: Sprite2D = $AsukaEyes/EyesNormal

@export var asuka_pose: int = 0:
	set(new_pose):
		asuka_pose = new_pose
		set_asuka_pose(asuka_pose)

func reset_asuka_pose() -> void:
	exp_pleased.visible = false
	exp_talking.visible = false
	exp_upset.visible = false
	eyes_closed.visible = false
	eyes_lookaway.visible = false
	eyes_normal.visible = false


# ----- PLEASED -----

func set_asuka_pleased_eyes_closed() -> void:
	reset_asuka_pose()
	exp_pleased.visible = true
	eyes_closed.visible = true

func set_asuka_pleased_eyes_lookaway() -> void:
	reset_asuka_pose()
	exp_pleased.visible = true
	eyes_lookaway.visible = true

func set_asuka_pleased_eyes_normal() -> void:
	reset_asuka_pose()
	exp_pleased.visible = true
	eyes_normal.visible = true


# ----- TALKING -----

func set_asuka_talking_eyes_closed() -> void:
	reset_asuka_pose()
	exp_talking.visible = true
	eyes_closed.visible = true

func set_asuka_talking_eyes_lookaway() -> void:
	reset_asuka_pose()
	exp_talking.visible = true
	eyes_lookaway.visible = true

func set_asuka_talking_eyes_normal() -> void:
	reset_asuka_pose()
	exp_talking.visible = true
	eyes_normal.visible = true


# ----- UPSET -----

func set_asuka_upset_eyes_closed() -> void:
	reset_asuka_pose()
	exp_upset.visible = true
	eyes_closed.visible = true

func set_asuka_upset_eyes_lookaway() -> void:
	reset_asuka_pose()
	exp_upset.visible = true
	eyes_lookaway.visible = true
	#asuka_pose = 8

func set_asuka_upset_eyes_normal() -> void:
	reset_asuka_pose()
	exp_upset.visible = true
	eyes_normal.visible = true
	#asuka_pose = 9


func set_asuka_pose(asuka_pose: int) -> void:
	print("aaaaaa")
	match asuka_pose:
		1:
			set_asuka_pleased_eyes_closed()
		2:
			set_asuka_pleased_eyes_lookaway()
		3:
			set_asuka_pleased_eyes_normal()
		4:
			set_asuka_talking_eyes_closed()
		5:
			set_asuka_talking_eyes_lookaway()
		6:
			set_asuka_talking_eyes_normal()
		7:
			set_asuka_upset_eyes_closed()
		8:
			set_asuka_upset_eyes_lookaway()
		9:
			set_asuka_upset_eyes_normal()
		_:
			reset_asuka_pose()
