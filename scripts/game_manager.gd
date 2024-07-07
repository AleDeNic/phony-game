extends Node

enum PlayerState { FREE, ZOOMING_IN, ZOOMING_OUT }
enum PhoneState { OFF, APPS, OPTIONS, CAMERA, CHATS, ASUKA_CHAT }

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

func set_player_state(new_state: PlayerState) -> void:
	player_state = new_state
	match player_state:
		PlayerState.ZOOMING_IN:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		PlayerState.ZOOMING_OUT, PlayerState.FREE:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func set_phone_state(new_state: PhoneState) -> void:
	phone_state = new_state

func start_dialogue(dialogue_resource: Resource, start_from: String) -> void:
	DialogueManager.show_dialogue_balloon(dialogue_resource, start_from)

func pause_dialogue() -> void:
	DialogueManager.show_dialogue_balloon(null)

func exit_phone() -> void:
	set_phone_state(PhoneState.OFF)
	set_player_state(PlayerState.ZOOMING_OUT)

func is_battery_active() -> bool:
	return phone_state not in [PhoneState.OFF, PhoneState.OPTIONS]
