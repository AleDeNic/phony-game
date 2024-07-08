extends Node

enum PlayerState { FREE, ZOOMING_IN, ZOOMING_OUT, IN_DIALOGUE }
enum PhoneState { OFF, APPS, OPTIONS, CAMERA, CHATS, ASUKACHAT }

@export var max_battery: float = 100.0
@export var max_stress: float = 100.0
@export var phone_stress_heal: float = 1.0
@export var asuka_stress_increase: float = 2.0
@export var window_stress_increase: float = 1.5
@export var effects_increase_speed: float = 1.0

var player_state: PlayerState = PlayerState.FREE
var phone_state: PhoneState = PhoneState.OFF

@onready var player: CharacterBody2D = %Player
@onready var phone: Area2D = $"../Phone"
@onready var camera: Camera2D = $"../Player/Camera2D"

var active_balloon: Node = null
var current_dialogue_area: Area2D = null

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	
func process(_delta: float) -> void:
	if player_state == PlayerState.IN_DIALOGUE and current_dialogue_area:
		if not current_dialogue_area.overlaps_body(player):
			end_dialogue()
	print_player_state(player_state)

# ---------- DIALOGUES -----------
func start_dialogue(dialogue_resource: Resource, start_from: String, dialogue_area: Area2D) -> void:
	set_player_state(PlayerState.IN_DIALOGUE)
	player.set_dialogue()
	active_balloon = DialogueManager.show_dialogue_balloon(dialogue_resource, start_from)
	current_dialogue_area = dialogue_area
	
func end_dialogue() -> void:
	if active_balloon and is_instance_valid(active_balloon):
		active_balloon.queue_free()
	active_balloon = null
	current_dialogue_area = null
	set_player_state(PlayerState.ZOOMING_OUT)
	player.end_dialogue()  

func pause_dialogue() -> void:
	if active_balloon and is_instance_valid(active_balloon):
		if active_balloon.has_method("pause"):
			active_balloon.pause()
		else:
			active_balloon.hide()
	set_player_state(PlayerState.FREE)
	
func resume_dialogue() -> void:
	if active_balloon and is_instance_valid(active_balloon):
		if active_balloon.has_method("resume"):
			active_balloon.resume()
		else:
			active_balloon.show()
	set_player_state(PlayerState.IN_DIALOGUE)
	
func _on_dialogue_ended(_resource: DialogueResource) -> void:
	end_dialogue()
	camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
	player.set_free()



# ---------- PLAYER AND PHONE STATE -----------
func set_player_state(new_state: PlayerState) -> void:
	player_state = new_state
	match player_state:
		PlayerState.ZOOMING_IN, PlayerState.IN_DIALOGUE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		PlayerState.ZOOMING_OUT, PlayerState.FREE:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func set_phone_state(new_state: PhoneState) -> void:
	phone_state = new_state

func is_battery_active() -> bool:
	return phone_state not in [PhoneState.OFF, PhoneState.OPTIONS]

func print_player_state(state):
	match state:
		PlayerState.FREE:
			print("FREE")
		PlayerState.ZOOMING_IN:
			print("ZOOMING_IN")
		PlayerState.ZOOMING_OUT:
			print("ZOOMING_OUT")
		PlayerState.IN_DIALOGUE:
			print("IN_DIALOGUE")
