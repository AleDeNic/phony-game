class_name GameManager
extends Node

enum PlayerState { FREE, ZOOMING_IN, ZOOMING_OUT, FOCUS, IN_PHONE }
enum PhoneState { OFF, APPS, OPTIONS, CAMERA, CHATS, ASUKACHAT }
@export var max_battery: float = 100.0
@export var max_stress: float = 100.0
@export var phone_stress_heal: float = 1.0
@export var asuka_stress_increase: float = 2.0
@export var window_stress_increase: float = 1.5
@export var effects_increase_speed: float = 1.0

var player_state: PlayerState = PlayerState.FREE
var phone_state: PhoneState   = PhoneState.OFF

@onready var player: CharacterBody2D = %Player
@onready var phone: Area2D = $"../Phone"
@onready var camera: Camera2D = $"../Player/Camera2D"

var active_balloon: Node          = null
var current_dialogue_area: Area2D = null


func _ready() -> void:
	initialize_player_state()
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)


func _process(_delta: float) -> void:
	if player_state == PlayerState.FOCUS and current_dialogue_area:
		if not current_dialogue_area.overlaps_body(player):
			end_dialogue()
	print_player_state(player_state)


# ----- DIALOGUES -----
func start_dialogue(dialogue_resource: Resource, start_from: String, dialogue_area: Area2D) -> void:
	set_player_to_focus()
	active_balloon = DialogueManager.show_dialogue_balloon(dialogue_resource, start_from)
	current_dialogue_area = dialogue_area


func end_dialogue() -> void:
	if active_balloon and is_instance_valid(active_balloon):
		active_balloon.queue_free()
	active_balloon = null
	current_dialogue_area = null
	set_player_zooming_out()


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
	set_player_state(PlayerState.FOCUS)


func _on_dialogue_ended(_resource: DialogueResource) -> void:
	end_dialogue()
	camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
	set_player_free()


# ---------- PLAYER STATE -----------
func initialize_player_state() -> void:
	set_player_free()


func set_player_state(new_state: PlayerState) -> void:
	player_state = new_state
	match player_state:
		PlayerState.IN_PHONE, PlayerState.FOCUS:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		PlayerState.ZOOMING_IN, PlayerState.ZOOMING_OUT, PlayerState.FREE:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func get_player_state() -> PlayerState:
	return player_state


func set_player_free() -> void:
	set_player_state(PlayerState.FREE)
	player.set_free()

func set_player_zooming_in() -> void:
	set_player_state(PlayerState.ZOOMING_IN)

func set_player_zooming_out() -> void:
	set_player_state(PlayerState.ZOOMING_OUT)

func set_player_to_focus() -> void:
	set_player_state(PlayerState.FOCUS)

func set_player_in_phone() -> void:
	set_player_state(PlayerState.IN_PHONE)


func is_player_free() -> bool:
	return player_state == PlayerState.FREE

func is_player_zooming_in() -> bool:
	return player_state == PlayerState.ZOOMING_IN

func is_player_zooming_out() -> bool:
	return player_state == PlayerState.ZOOMING_OUT

func is_player_zooming() -> bool:
	return player_state in [PlayerState.ZOOMING_IN, PlayerState.ZOOMING_OUT]

func is_player_to_focus() -> bool:
	return player_state == PlayerState.FOCUS

func is_player_in_phone() -> bool:
	return player_state == PlayerState.IN_PHONE


func transition_player_to_free() -> void:
	if is_player_zooming_out():
		set_player_free()


func zoom_player(zoom_value: Vector2, zoom_speed: float) -> void:
	player.zoom_to(zoom_value, zoom_speed)


# ---------- PHONE STATE -----------
func set_phone_state(new_state: PhoneState) -> void:
	phone_state = new_state


func get_phone_state() -> PhoneState:
	return phone_state


# ----- IDK -----
func is_battery_active() -> bool:
	return phone_state not in [PhoneState.OFF, PhoneState.OPTIONS]


# ----- DEBUG FUNCTIONS -----
func print_player_state(state):
	match state:
		PlayerState.FREE:
			print("Player state: FREE")
		PlayerState.ZOOMING_IN:
			print("Player state: ZOOMING_IN")
		PlayerState.ZOOMING_OUT:
			print("Player state: ZOOMING_OUT")
		PlayerState.FOCUS:
			print("Player state: FOCUS")
		PlayerState.IN_PHONE:
			print("Player state: IN_PHONE")


func print_phone_state(state):
	match state:
		PhoneState.OFF:
			print("Phone state: OFF")
		PhoneState.APPS:
			print("Phone state: APPS")
		PhoneState.OPTIONS:
			print("Phone state: OPTIONS")
		PhoneState.CAMERA:
			print("Phone state: CAMERA")
		PhoneState.CHATS:
			print("Phone state: CHATS")
		PhoneState.ASUKACHAT:
			print("Phone state: ASUKACHAT")
