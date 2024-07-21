extends Node

#region Variables
enum Pose {
	A2,
	A3
}
enum Face {
	UPSET,
	PLEASED,
	TALKING,
	LAUGH
}
enum Eyes {
	NORMAL,
	CLOSED,
	LOOKAWAY,
	SMILE
}
enum Dialogue {
	INACTIVE,
	ACTIVE,
	ENDED
}

@onready var pose_state: Pose
@onready var face_state: Face
@onready var eye_state: Eyes
@onready var dialogue_state: Dialogue = Dialogue.INACTIVE
#endregion


func _ready() -> void:
	set_asuka(Pose.A2, Face.PLEASED, Eyes.NORMAL)



func set_asuka(pose: Pose, face: Face, eyes: Eyes) -> void:
	set_pose(pose)
	set_face(face)
	set_eyes(eyes)


#region DIALOGUE
func set_dialogue(new_state: Dialogue) -> void:
	dialogue_state = new_state
	print("Dialogue -> ", get_dialogue_value())


func get_dialogue() -> Dialogue:
	return dialogue_state


func get_dialogue_value() -> String:
	match dialogue_state:
		Dialogue.INACTIVE:
			return "INACTIVE"
		Dialogue.ACTIVE:
			return "ACTIVE"
		Dialogue.ENDED:
			return "ENDED"
		_:
			return "UNKNOWN"


func set_dialogue_inactive() -> void:
	set_dialogue(Dialogue.INACTIVE)


func set_dialogue_active() -> void:
	set_dialogue(Dialogue.ACTIVE)


func set_dialogue_ended() -> void:
	set_dialogue(Dialogue.ENDED)


func is_dialogue_inactive() -> bool:
	return dialogue_state == Dialogue.INACTIVE


func is_dialogue_active() -> bool:
	return dialogue_state == Dialogue.ACTIVE


func is_dialogue_ended() -> bool:
	return dialogue_state == Dialogue.ENDED
#endregion


#region POSE
func set_pose(new_pose: Pose) -> void:
	pose_state = new_pose
	print("Asuka pose -> ", get_pose_value())


func get_pose() -> Pose:
	return pose_state


func get_pose_value() -> String:
	match pose_state:
		Pose.A2:
			return "A2"
		Pose.A3:
			return "A3"
		_:
			return "UNKNOWN"


func is_a2() -> bool:
	return pose_state == Pose.A2


func is_a3() -> bool:
	return pose_state == Pose.A3
#endregion


#region FACE
func set_face(new_face: Face) -> void:
	face_state = new_face
	print("Asuka -> ", get_face_value())


func get_face() -> Face:
	return face_state


func get_face_value() -> String:
	match face_state:
		Face.PLEASED:
			return "PLEASED"
		Face.TALKING:
			return "TALKING"
		Face.UPSET:
			return "UPSET"
		_:
			return "UNKNOWN"


func is_pleased() -> bool:
	return face_state == Face.PLEASED


func is_talking() -> bool:
	return face_state == Face.TALKING


func is_upset() -> bool:
	return face_state == Face.UPSET
#endregion


#region EYES
func set_eyes(new_state: Eyes) -> void:
	eye_state = new_state
	print("Eyes -> ", get_eyes_value())


func get_eyes() -> Eyes:
	return eye_state


func get_eyes_value() -> String:
	match eye_state:
		Eyes.NORMAL:
			return "NORMAL"
		Eyes.CLOSED:
			return "CLOSED"
		Eyes.LOOKAWAY:
			return "LOOKAWAY"
		_:
			return "UNKNOWN"


func are_eyes_normal() -> bool:
	return eye_state == Eyes.NORMAL


func are_eyes_closed() -> bool:
	return eye_state == Eyes.CLOSED


func are_eyes_lookaway() -> bool:
	return eye_state == Eyes.LOOKAWAY
	#endregion


#region RESET
func reset_all() -> void:
	set_asuka(Pose.A2, Face.PLEASED, Eyes.NORMAL)
	set_dialogue_inactive()
#endregion
