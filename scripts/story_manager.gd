extends Node

@onready var game_manager: GameManager = $"../GameManager"
@onready var player: CharacterBody2D = %Player
@onready var asuka: Area2D = $"../Asuka"
@onready var phone: Area2D = $"../Phone"
@onready var camera: Camera2D = $"../Player/Camera2D"

var active_balloon: Node = null
var current_dialogue_area: Area2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if game_manager.player_state == GameManager.PlayerState.FOCUS and current_dialogue_area:
		if not current_dialogue_area.overlaps_body(player):
			end_dialogue()
	#print_player_state(player_state)

# ----- DIALOGUES -----
func start_dialogue(dialogue_resource: Resource, start_from: String, dialogue_area: Area2D) -> void:
	active_balloon = DialogueManager.show_dialogue_balloon(dialogue_resource, start_from)
	current_dialogue_area = dialogue_area


func end_dialogue() -> void:
	if active_balloon and is_instance_valid(active_balloon):
		active_balloon.queue_free()
	active_balloon = null
	current_dialogue_area = null
	game_manager.set_player_zooming_out()


func pause_dialogue() -> void:
	if active_balloon and is_instance_valid(active_balloon):
		if active_balloon.has_method("pause"):
			active_balloon.pause()
		else:
			active_balloon.hide()
	game_manager.set_player_state(GameManager.PlayerState.FREE)


func resume_dialogue() -> void:
	if active_balloon and is_instance_valid(active_balloon):
		if active_balloon.has_method("resume"):
			active_balloon.resume()
		else:
			active_balloon.show()
	game_manager.set_player_state(GameManager.PlayerState.FOCUS)


func _on_dialogue_ended(_resource: DialogueResource) -> void:
	end_dialogue()
	camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
	game_manager.set_player_free()
