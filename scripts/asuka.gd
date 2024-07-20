extends Area2D

#region Variables
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
#endregion

# ----- READY AND PROCESS -----

func _process(_delta: float) -> void:
	update_asuka_sprites()


#region Interaction
func _on_area_entered(_area: Area2D) -> void:
	enter()

func enter() -> void:
	if Player.is_free() and not Player.is_drifting_to_phone():
		match Asuka.get_dialogue():
			Asuka.Dialogue.INACTIVE:
				player.set_target(global_position, player.focus_speed_asuka)
				Player.set_focusing_on_asuka()
				await get_tree().create_timer(1.0).timeout
				DialogueManager.show_dialogue_balloon_scene(dialogue_balloon, dialogue_resource, dialogue_start)
				Asuka.set_dialogue_active()
				Player.set_focus_on_asuka()
			Asuka.Dialogue.ACTIVE:
				player.set_target(global_position, player.focus_speed_asuka)
				Player.set_focusing_on_asuka()
				await get_tree().create_timer(1.0).timeout
				Player.set_focus_on_asuka()
			Asuka.Dialogue.ENDED:
				pass

		camera.set_camera_zoom(camera.asuka_zoom_value, camera.asuka_zoom_speed)
	else:
		return

func exit() -> void:
	if Player.is_unfocusing():
		camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
		await get_tree().create_timer(1.0).timeout

	Player.set_unfocus()
	Player.set_free()
#endregion

#region Sprites
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
			arms_3.show()
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
	match Asuka.get_eyes():
		Asuka.Eyes.NORMAL:
			eyes.frame = 0
		Asuka.Eyes.CLOSED:
			eyes.frame = 1
		Asuka.Eyes.LOOKAWAY:
			eyes.frame = 2
		Asuka.Eyes.SMILE:
			eyes.frame = 3
#endregion
