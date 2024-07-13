extends Node

var active_balloon: Node = null
var current_dialogue_area: Area2D = null

@onready var dialogue_balloon: String = "res://scenes/balloons/dialogue_balloon.tscn"

@onready var asuka: Area2D = get_node("/root/World/Asuka")
@onready var points: int = 0
@onready var dialogue_scene: String = ""
@onready var dialogue_resource: Resource = null
@onready var dialogue_start: String = ""

var current_line_id: String = ""
var last_non_prioritized_line_id: String = ""
var dialogue_resource_last_lines: Dictionary = {}
var dialogue_last_lines: Dictionary = {}
var last_non_prioritized_dialogue: Dictionary = {}
var prioritized_dialogue: Resource = null
var dialogue_queue: Array = []

var non_prioritized_balloon: Node = null

# TODO: Handle prioritized dialogues. There needs to be only one at a time, otherwise angry dialogues will overlap
# ----- INITIALIZATION AND PHYSICS -----

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	print("Ready function executed. DialogueManager.dialogue_ended connected.")

# ----- STATE GETTERS -----
func get_points() -> int:
	return points

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
func add_points(value: int) -> void:
	points += value
	print("Points added. Current points: ", points)

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

func start_dialogue(dialogue_scene: String, dialogue_resource: Resource, start_from: String, dialogue_area: Area2D, prioritize: bool = false) -> void:
	print("Attempting to start dialogue: ", dialogue_resource.resource_path)
	
	if prioritized_dialogue and not prioritize:
		print("A prioritized dialogue is active. Queueing this dialogue.")
		dialogue_queue.append({
			"scene": dialogue_scene,
			"resource": dialogue_resource,
			"start_from": start_from,
			"area": dialogue_area
		})
		print("Dialogue queued. Current queue size: ", dialogue_queue.size())
		return
	
	if prioritize:
		if dialogue_resource != prioritized_dialogue:
			if prioritized_dialogue == null:
				last_non_prioritized_dialogue = {
					"scene": dialogue_scene,
					"resource": dialogue_resource,
					"start_from": dialogue_last_lines.get(dialogue_resource.resource_path, start_from),
					"area": dialogue_area
				}
				print("Last non-prioritized dialogue set: ", last_non_prioritized_dialogue)
			if active_balloon and is_instance_valid(active_balloon):
				active_balloon.visible = false  # Hide the non-prioritized dialogue balloon
				non_prioritized_balloon = active_balloon
				active_balloon = null
		prioritized_dialogue = dialogue_resource
		dialogue_queue.clear()
		print("Prioritized dialogue set. Queue cleared.")
	
	if active_balloon and is_instance_valid(active_balloon):
		active_balloon.queue_free()
		print("Previous active balloon freed.")
	
	set_dialogue_resource(dialogue_resource)
	set_dialogue_scene(dialogue_scene)
	set_dialogue_start(start_from)
	
	var start_id = dialogue_last_lines.get(dialogue_resource.resource_path, start_from)
	print("Starting dialogue at ID: ", start_id)
	
	active_balloon = DialogueManager.show_dialogue_balloon_scene(dialogue_scene, dialogue_resource, start_id)
	current_dialogue_area = dialogue_area
	
	if not DialogueManager.got_dialogue.is_connected(_on_got_dialogue):
		DialogueManager.got_dialogue.connect(_on_got_dialogue)
		print("Connected to DialogueManager.got_dialogue signal.")

func end_dialogue() -> void:
	print("Dialogue ended")
	if active_balloon and is_instance_valid(active_balloon):
		active_balloon.queue_free()
		print("Active balloon freed.")
	active_balloon = null
	
	if current_dialogue_area and is_instance_valid(current_dialogue_area):
		if current_dialogue_area.has_method("exit"):
			current_dialogue_area.exit()
		print("Current dialogue area exited.")
	current_dialogue_area = null
	
	print("Current ID for dialogue: ", current_line_id)
	
	var was_prioritized = (dialogue_resource == prioritized_dialogue)
	if was_prioritized:
		prioritized_dialogue = null
		print("Prioritized dialogue ended.")
		if last_non_prioritized_dialogue:
			var dialogue_to_resume: Dictionary = last_non_prioritized_dialogue
			last_non_prioritized_dialogue = {}
			print("Resuming last non-prioritized dialogue: ", dialogue_to_resume)
			if non_prioritized_balloon and is_instance_valid(non_prioritized_balloon):
				non_prioritized_balloon.visible = true
				active_balloon = non_prioritized_balloon
				non_prioritized_balloon = null
			else:
				get_tree().create_timer(0.1).timeout.connect(func():
					start_dialogue(
						dialogue_to_resume["scene"],
						dialogue_to_resume["resource"],
						dialogue_to_resume["start_from"],
						dialogue_to_resume["area"],
						false
					)
				)
	elif dialogue_queue.size() > 0:
		print("Starting next queued dialogue.")
		get_tree().create_timer(0.1).timeout.connect(start_next_queued_dialogue)
	else:
		print("No prioritized dialogue or queued dialogue.")
	
	current_line_id = ""

func start_next_queued_dialogue() -> void:
	if not dialogue_queue.is_empty():
		var next_dialogue = dialogue_queue.pop_front()
		print("Starting next queued dialogue: ", next_dialogue)
		start_dialogue(next_dialogue["scene"], next_dialogue["resource"], next_dialogue["start_from"], next_dialogue["area"], false)
	else:
		print("No more dialogues in the queue.")

# ----- SIGNALS -----

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	print("Dialogue ended signal received for resource: ", _resource.resource_path)
	end_dialogue()
	if prioritized_dialogue == null:
		print("No prioritized dialogue active.")
	
func _on_got_dialogue(line: DialogueLine) -> void:
	current_line_id = line.id
	print("Received dialogue line: ", line.id)
	if dialogue_resource != null:
		dialogue_last_lines[dialogue_resource.resource_path] = line.id
		print("Updated dialogue last line ID for resource: ", dialogue_resource.resource_path)
	
	if dialogue_resource != prioritized_dialogue and last_non_prioritized_dialogue:
		last_non_prioritized_dialogue["start_from"] = line.id
		print("Updated last non-prioritized dialogue start from ID: ", line.id)
