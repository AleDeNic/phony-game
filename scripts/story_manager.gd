extends Node

@onready var player_manager: PlayerManager = %PlayerManager
@onready var player: CharacterBody2D = %Player
@onready var asuka: Area2D = $"../Asuka"
@onready var phone: Area2D = $"../Phone"
@onready var camera: Camera2D = $"../Player/Camera2D"

var active_balloon: Node = null
var current_dialogue_area: Area2D = null


# ----- INITIALIZATION AND PHYSICS -----

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _physics_process(_delta: float) -> void:
	if player_manager.player_state == PlayerManager.PlayerState.FOCUS and current_dialogue_area:
		if not current_dialogue_area.overlaps_body(player):
			end_dialogue()
	#print_player_state(player_state)


# ----- DIALOGUES -----

func start_dialogue(dialogue_resource: Resource, start_from: String, dialogue_area: Area2D) -> void:
	#print("dialogue started")
	active_balloon = DialogueManager.show_dialogue_balloon(dialogue_resource, start_from)
	current_dialogue_area = dialogue_area

func end_dialogue() -> void:
	#print("dialogue ended")
	if active_balloon and is_instance_valid(active_balloon):
		active_balloon.queue_free()
	active_balloon = null
	current_dialogue_area = null
	camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
	player_manager.set_player_free()
	player_manager.print_player_state(player_manager.player_state)

func pause_dialogue() -> void:
	if active_balloon and is_instance_valid(active_balloon):
		#print("dialogue paused")
		if active_balloon.has_method("pause"):
			active_balloon.pause()
		else:
			active_balloon.hide()

func resume_dialogue() -> void:
	if active_balloon and is_instance_valid(active_balloon):
		#print("dialogue resumed")
		if active_balloon.has_method("resume"):
			active_balloon.resume()
		else:
			active_balloon.show()


# ----- SIGNALS -----

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	end_dialogue()

