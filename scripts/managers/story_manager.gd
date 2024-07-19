extends Node

var active_balloon: Node = null
var current_dialogue_area: Area2D = null

@onready var dialogue_balloon: String = "res://scenes/balloons/dialogue_balloon.tscn"

@onready var asuka: Area2D = get_node("/root/World/Asuka")
@onready var dialogue_scene: String = ""
@onready var dialogue_resource: Resource = null
@onready var dialogue_start: String = ""

var dialogue_resource_last_lines: Dictionary = {}
var prioritized_dialogue: Resource = null

var non_prioritized_balloon: Node = null

var angry_dialogue_active: bool = false

# TODO: Handle prioritized dialogues. There needs to be only one at a time, otherwise angry dialogues will overlap
# ----- INITIALIZATION AND PHYSICS -----

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	print("Ready function executed. DialogueManager.dialogue_ended connected.")

# ----- STATE GETTERS -----
func get_dialogue_resource() -> Resource:
	return dialogue_resource

func get_dialogue_scene() -> String:
	return dialogue_scene

func get_dialogue_start() -> String:
	return dialogue_start

func get_dialogue_area() -> Area2D:
	return current_dialogue_area

func get_active_balloon() -> Node:
	return active_balloon


# ----- STATE SETTERS -----

func set_dialogue_resource(resource: Resource) -> void:
	dialogue_resource = resource
	print("Dialogue resource set to: ", resource.resource_path)

func set_dialogue_scene(scene: String) -> void:
	dialogue_scene = scene
	print("Dialogue scene set to: ", scene)

func set_dialogue_start(start: String) -> void:
	dialogue_start = start
	print("Dialogue start set to: ", start)

func set_dialogue_area(area: Area2D) -> void:
	current_dialogue_area = area
	print("Dialogue area set to: ", area)

# ----- DIALOGUES -----

func start_dialogue(dialogue_scene: String, dialogue_resource: Resource, start_from: String, dialogue_area: Area2D) -> void:
	print("Attempting to start dialogue: ", dialogue_resource.resource_path)

	set_dialogue_resource(dialogue_resource)
	set_dialogue_scene(dialogue_scene)
	set_dialogue_start(start_from)

	active_balloon = DialogueManager.show_dialogue_balloon_scene(dialogue_scene, dialogue_resource, start_from)
	current_dialogue_area = dialogue_area

func restore_previous_state(previous_state: Player.State) -> void:
	Player.set_state(previous_state)

# ----- SIGNALS -----

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	print("Dialogue ended signal received for resource: ", _resource.resource_path)
