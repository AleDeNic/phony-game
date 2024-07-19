extends Area2D

@export var dialogue_resource: Resource = load("res://dialogues/asuka.dialogue")
@export var dialogue_start: String = "asuka_intro"

@onready var pose_2: Sprite2D = get_node("/root/World/Background/TrainInterior/Asuka2/AsukaPose2")
@onready var face_2: Sprite2D = get_node("/root/World/Background/TrainInterior/Asuka2/AsukaFace2")
@onready var eyes_2: Sprite2D = get_node("/root/World/Background/TrainInterior/Asuka2/AsukaEyes2")
@onready var pose_3: Sprite2D = get_node("/root/World/Background/TrainInterior/Asuka3/AsukaPose3")
@onready var face_3: Sprite2D = get_node("/root/World/Background/TrainInterior/Asuka3/AsukaFace3")
@onready var eyes_3: Sprite2D = get_node("/root/World/Background/TrainInterior/Asuka3/AsukaEyes3")
@onready var arms_3: Sprite2D = get_node("/root/World/Background/TrainInterior/Asuka3/AsukaArms3")

@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var player: CharacterBody2D = %Player

var is_dialogue_started: bool = false


# ----- READY AND PROCESS -----

func _process(_delta: float) -> void:
	update_asuka_sprites()


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


# ----- SPRITES -----

func update_asuka_sprites() -> void:
	pass
