extends Area2D

@export var dialogue_resource: Resource = load("res://dialogues/asuka.dialogue")
@export var dialogue_start: String = "asuka_intro"

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

@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var player: CharacterBody2D = %Player

var is_dialogue_started: bool = false

func _process(_delta: float) -> void:
	update_asuka_visuals()

# ----- INTERACTIONS -----

func _on_area_entered(_area: Area2D) -> void:
	if PlayerManager.is_player_free() or PlayerManager.is_player_focusing_out():
		enter_asuka()


func enter_asuka() -> void:
	player.set_focus_target(global_position, player.focus_speed_asuka)
	PlayerManager.set_player_focusing_on_asuka()

	if !is_dialogue_started:
		StoryManager.start_dialogue(StoryManager.dialogue_balloon, dialogue_resource, dialogue_start, self, false)
		is_dialogue_started = true
	await get_tree().create_timer(1.0).timeout
	if PlayerManager.is_player_focusing_on_asuka():
		PlayerManager.set_player_focused_asuka()


func exit() -> void:
	PlayerManager.set_player_focusing_out()
	camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)

	await get_tree().create_timer(1.0).timeout
	if PlayerManager.is_player_focusing_out():
		PlayerManager.set_player_free()

# ----- UTILS -----
func update_asuka_visuals() -> void:
	if AsukaManager.is_asuka_pose_2():
		asuka_02.hide()
		asuka_03.show()
		asuka_arms_03.show()
	elif AsukaManager.is_asuka_pose_3():
		asuka_02.show()
		asuka_03.hide()
		asuka_arms_03.hide()

	var expr_pleased: Sprite2D = expr_pleased_02 if AsukaManager.is_asuka_pose_3() else expr_pleased_03
	var expr_talking: Sprite2D = expr_talking_02 if AsukaManager.is_asuka_pose_3() else expr_talking_03
	var expr_upset: Sprite2D   = expr_upset_02 if AsukaManager.is_asuka_pose_3() else expr_upset_03

	expr_pleased.hide()
	expr_talking.hide()
	expr_upset.hide()

	if AsukaManager.is_expression_pleased():
		expr_pleased.show()
	elif AsukaManager.is_expression_talking():
		expr_talking.show()
	elif AsukaManager.is_expression_upset():
		expr_upset.show()

	var eyes_normal: Sprite2D   = eyes_normal_02 if AsukaManager.is_asuka_pose_3() else eyes_normal_03
	var eyes_closed: Sprite2D   = eyes_closed_02 if AsukaManager.is_asuka_pose_3() else eyes_closed_03
	var eyes_lookaway: Sprite2D = eyes_lookaway_02 if AsukaManager.is_asuka_pose_3() else eyes_lookaway_03

	eyes_normal.hide()
	eyes_closed.hide()
	eyes_lookaway.hide()

	if AsukaManager.are_eyes_normal():
		eyes_normal.show()
	elif AsukaManager.are_eyes_closed():
		eyes_closed.show()
	elif AsukaManager.are_eyes_lookaway():
		eyes_lookaway.show()
