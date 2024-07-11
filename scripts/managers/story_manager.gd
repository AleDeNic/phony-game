extends Node

var active_balloon: Node = null
var current_dialogue_area: Area2D = null

### If you need to add a new balloon, copy the scene below. Remember that if you need
### to change the balloon's behaviour, you will need to create another script under scripts/balloons.
@onready var asuka_dialogue: String = "res://scenes/balloons/dialogue_balloon.tscn"
#@onready var window_monologue: String = "res://scenes/balloons/window_monologue.tscn"
#@onready var phone_chat: String = "res://scenes/balloons/phone_chat.tscn"
# @onready var phone_balloon: String = "path/to/phone_balloon.tscn"

@onready var asuka: Area2D = get_node("/root/World/Asuka")

# ----- INITIALIZATION AND PHYSICS -----

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

# ----- DIALOGUES -----

func start_dialogue(dialogue_scene: String, dialogue_resource: Resource, start_from: String, dialogue_area: Area2D) -> void:
	print("Dialogue ", dialogue_resource.resource_path, " started")
	
	active_balloon = DialogueManager.show_dialogue_balloon_scene(dialogue_scene, dialogue_resource, start_from)
	current_dialogue_area = dialogue_area

func end_dialogue() -> void:
	print("Dialogue ended")
	
	if active_balloon and is_instance_valid(active_balloon):
		active_balloon.queue_free()
	active_balloon = null
	current_dialogue_area = null
	
	asuka.exit_asuka()

func pause_dialogue() -> void:
	if active_balloon and is_instance_valid(active_balloon):
		if active_balloon.has_method("pause"):
			active_balloon.pause()
		else:
			active_balloon.hide()

func resume_dialogue() -> void:
	if active_balloon and is_instance_valid(active_balloon):
		if active_balloon.has_method("resume"):
			active_balloon.resume()
		else:
			active_balloon.show()

# ----- SIGNALS -----

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	end_dialogue()

