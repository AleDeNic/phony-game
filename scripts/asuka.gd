extends Area2D

@export var dialogue_resource: Resource = load("res://dialogues/asuka.dialogue")
@export var dialogue_start: String = "asuka_intro"
@export var dialogue_balloon: Resource = load("res://scenes/balloons/dialogue_balloon.tscn")

@onready var asuka_2: Node2D = get_node("/root/World/Background/TrainInterior/Asuka2")
@onready var asuka_3: Node2D = get_node("/root/World/Background/TrainInterior/Asuka3")
@onready var pose_2: Sprite2D = get_node("/root/World/Background/TrainInterior/Asuka2/AsukaPose2")
@onready var pose_3: Sprite2D = get_node("/root/World/Background/TrainInterior/Asuka3/AsukaPose3")
@onready var face_2: AnimatedSprite2D = get_node("/root/World/Background/TrainInterior/Asuka2/AsukaFace2")
@onready var face_3: AnimatedSprite2D = get_node("/root/World/Background/TrainInterior/Asuka3/AsukaFace3")
@onready var eyes_2: AnimatedSprite2D = get_node("/root/World/Background/TrainInterior/Asuka2/AsukaEyes2")
@onready var eyes_3: AnimatedSprite2D = get_node("/root/World/Background/TrainInterior/Asuka3/AsukaEyes3")
@onready var arms_3: Sprite2D = get_node("/root/World/Background/TrainInterior/Asuka3/AsukaArms3")

@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var player: CharacterBody2D = %Player

var is_dialogue_started: bool = false


# ----- READY AND PROCESS -----

func _process(_delta: float) -> void:
	update_asuka_sprites()


# ----- INTERACTIONS -----

func _on_area_entered(_area: Area2D) -> void:
	if Player.is_free() or Player.is_unfocusing():
		enter()


func enter() -> void:
	player.set_target(global_position, player.focus_speed_asuka)
	Player.set_focusing_on_asuka()

	if !is_dialogue_started:
		DialogueManager.show_dialogue_balloon_scene(dialogue_balloon, dialogue_resource, dialogue_start)
		is_dialogue_started = true

	await get_tree().create_timer(1.0).timeout
	if Player.is_focusing_on_asuka():
		Player.set_focus_on_asuka()


func exit() -> void:
	Player.set_unfocus()
	camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
	
	await get_tree().create_timer(1.0).timeout
	if Player.is_unfocusing():
		Player.set_free()


# ----- UTILS -----

func update_asuka_sprites() -> void:
	match Asuka.get_pose():
		Asuka.Pose.A2:
			asuka_3.hide()
			arms_3.hide()
			asuka_2.show()
			set_face(face_2)
			set_eyes(eyes_2)
		Asuka.Pose.A3:
			asuka_2.hide()
			asuka_3.show()
			set_face(face_3)
			set_eyes(eyes_3)
			

func set_face(face: AnimatedSprite2D) -> void:
	match Asuka.get_face():
		Asuka.Face.UPSET:
			face.frame = 0
		Asuka.Face.PLEASED:
			face.frame = 1
		Asuka.Face.TALKING:
			face.frame = 2
		Asuka.Face.LAUGH:
			face.frame = 3

func set_eyes(eyes: AnimatedSprite2D) -> void:
	match Asuka.get_face():
		Asuka.Eyes.NORMAL:
			eyes.frame = 0
		Asuka.Eyes.CLOSED:
			eyes.frame = 1
		Asuka.Eyes.LOOKAWAY:
			eyes.frame = 2
		Asuka.Eyes.SMILE:
			eyes.frame = 3
