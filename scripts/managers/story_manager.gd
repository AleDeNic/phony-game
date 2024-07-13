extends Node

var active_balloon: Node          = null
var current_dialogue_area: Area2D = null

### If you need to add a new balloon, copy the scene below. Remember that if you need
### to change the balloon's behaviour, you will need to create another script under scripts/balloons.
@onready var dialogue_balloon: String = "res://scenes/balloons/dialogue_balloon.tscn"
# @onready var window_monologue: String = "res://scenes/balloons/window_monologue.tscn"
# @onready var phone_chat: String = "res://scenes/balloons/phone_chat.tscn"
# @onready var phone_balloon: String = "path/to/phone_balloon.tscn"

@onready var asuka: Area2D = get_node("/root/World/Asuka")
@onready var points: int = 0
@onready var dialogue_scene: String = ""
@onready var dialogue_resource: Resource = null
@onready var dialogue_start: String = ""
var current_line_id: String = ""
var dialogue_resource_last_lines: Dictionary = {}

var prioritized_dialogue: Resource = null


# ----- INITIALIZATION AND PHYSICS -----

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)


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
	print("Points: ", points)


func set_dialogue_resource(resource: Resource) -> void:
	dialogue_resource = resource


func set_dialogue_scene(scene: String) -> void:
	dialogue_scene = scene


func set_dialogue_start(start: String) -> void:
	dialogue_start = start
 

func set_dialogue_area(area: Area2D) -> void:
	current_dialogue_area = area


# ----- DIALOGUES -----

func start_dialogue(dialogue_scene: String, dialogue_resource: Resource, start_from: String, dialogue_area: Area2D, prioritize: bool = false) -> void:
	print("Dialogue ", dialogue_resource.resource_path, " started")
	
	if prioritized_dialogue and not prioritize:
		print("A prioritized dialogue is active. Cannot start a new non-prioritized dialogue.")
		return
	
	if prioritize:
		prioritized_dialogue = dialogue_resource
	
	if dialogue_resource != null and current_line_id != "":
		dialogue_resource_last_lines[dialogue_resource.resource_path] = current_line_id
	
	if active_balloon and is_instance_valid(active_balloon):
		active_balloon.queue_free()
	
	set_dialogue_resource(dialogue_resource)
	set_dialogue_scene(dialogue_scene)
	set_dialogue_start(start_from)
	
	var start_id = dialogue_resource_last_lines.get(dialogue_resource.resource_path, start_from)
	
	active_balloon = DialogueManager.show_dialogue_balloon_scene(dialogue_scene, dialogue_resource, start_id)
	current_dialogue_area = dialogue_area
	
	if not DialogueManager.got_dialogue.is_connected(_on_got_dialogue):
		DialogueManager.got_dialogue.connect(_on_got_dialogue)


func pause_dialogue() -> void:
	print("Dialogue paused at line ID: ", current_line_id)
	if active_balloon and is_instance_valid(active_balloon):
		active_balloon.queue_free()
	active_balloon = null
	current_dialogue_area = null

func end_dialogue() -> void:
	print("Dialogue ended")
	if active_balloon and is_instance_valid(active_balloon):
		active_balloon.queue_free()
	active_balloon = null
	
	if current_dialogue_area and is_instance_valid(current_dialogue_area):
		if current_dialogue_area.has_method("exit"):
			current_dialogue_area.exit()
	current_dialogue_area = null
	
	if dialogue_resource != null and current_line_id != "":
		dialogue_resource_last_lines[dialogue_resource.resource_path] = current_line_id
	
	print("Current ID for dialogue: ", current_line_id)
	current_line_id = ""
	
	if dialogue_resource == prioritized_dialogue:
		prioritized_dialogue = null

func resume_dialogue() -> void:
	if active_balloon and is_instance_valid(active_balloon):
		if active_balloon.has_method("resume"):
			active_balloon.resume()
		else:
			active_balloon.show()


# ----- CHECK POINTS -----
# func check_points(points: int):
#	if points > threshold:
#		...

# ----- SIGNALS -----

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	end_dialogue()
	if prioritized_dialogue == null:
		pass
	
func _on_got_dialogue(line: DialogueLine) -> void:
	current_line_id = line.id
	if dialogue_resource != null:
		dialogue_resource_last_lines[dialogue_resource.resource_path] = current_line_id

