extends Area2D

@export var dialogue_resource: Resource = load("res://dialogues/asuka.dialogue")
@export var dialogue_start: String = "asuka_intro"

@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var player: CharacterBody2D = %Player

enum AsukaMoods {
	NEUTRAL,
	HAPPY,
	SAD,
	ANGRY
}

var is_dialogue_started: bool = false

@onready var mood: AsukaMoods = AsukaMoods.NEUTRAL


# ----- INITIALIZATION AND PHYSICS -----

# ----- INTERACTIONS -----

func _on_area_entered(_area: Area2D) -> void:
	if PlayerManager.is_player_free() or PlayerManager.is_player_focusing_out():
		enter_asuka()

func enter_asuka() -> void:
	player.set_focus_target(global_position, player.focus_speed_asuka)
	PlayerManager.set_player_focusing_on_asuka()
	camera.set_camera_zoom(camera.asuka_zoom_value, camera.asuka_zoom_speed)
	#get_eyes_attention()
	if !is_dialogue_started:
		StoryManager.start_dialogue(StoryManager.dialogue_balloon, dialogue_resource, dialogue_start, self, false)
		is_dialogue_started = true
	await get_tree().create_timer(1.0).timeout
	if PlayerManager.is_player_focusing_on_asuka():
		PlayerManager.set_player_focused_asuka()

func exit() -> void:
	PlayerManager.set_player_focusing_out()
	camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
	#get_eyes_attention()
	await get_tree().create_timer(1.0).timeout
	if PlayerManager.is_player_focusing_out():
		PlayerManager.set_player_free()


# ----- STATE SETTERS -----
func set_asuka_neutral() -> void:
	mood = AsukaMoods.NEUTRAL

func set_asuka_happy() -> void:
	mood = AsukaMoods.HAPPY

func set_asuka_sad() -> void:
	mood = AsukaMoods.SAD

func set_asuka_angry() -> void:
	mood = AsukaMoods.ANGRY


# ----- STATE GETTERS -----
func get_asuka_state() -> AsukaMoods:
	return mood


func get_asuka_state_value():
	match mood:
		AsukaMoods.NEUTRAL:
			return "NEUTRAL"
		AsukaMoods.HAPPY:
			return "HAPPY"
		AsukaMoods.SAD:
			return "SAD"
		AsukaMoods.ANGRY:
			return "ANGRY"


func is_asuka_neutral() -> bool:
	return mood == AsukaMoods.NEUTRAL

func is_asuka_happy() -> bool:
	return mood == AsukaMoods.HAPPY

func is_asuka_sad() -> bool:
	return mood == AsukaMoods.SAD

func is_asuka_angry() -> bool:
	return mood == AsukaMoods.ANGRY


# ----- UTILS -----

#func get_eyes_attention() -> void:
	#await get_tree().create_timer(0.3).timeout
	#if PlayerManager.is_player_focusing_on_asuka():
		#eyes_sprite.frame = 1
	#elif PlayerManager.is_player_focusing_out():
		#eyes_sprite.frame = 0


# ----- A SIGNAL THAT CHANGES THE SPRITE BASED ON THE MOOD -----
# func _on_asuka_mood_changed() -> void:
#     match mood:
#         AsukaMoods.NEUTRAL:
#               asuka_sprite.texture = load("res://asuka_neutral.png")
#         AsukaMoods.HAPPY:
#               asuka_sprite.texture = load("res://asuka_happy.png")
#         AsukaMoods.SAD:
#               asuka_sprite.texture = load("res://asuka_sad.png")
#         AsukaMoods.ANGRY:
#               asuka_sprite.texture = load("res://asuka_angry.png")
