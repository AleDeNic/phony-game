extends Area2D

@export var dialogue_resource: Resource = load("res://dialogues/asuka.dialogue")
@export var dialogue_start: String = "asuka_intro"

@onready var timer: Timer = $AsukaTimer
@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var eyes_sprite: AnimatedSprite2D = $EyesSprite
@onready var game_manager: Node = $"../GameManager"
@onready var player: CharacterBody2D = %Player


# ----- INITIALIZATION AND PHYSICS -----
func _ready() -> void:
	eyes_sprite.frame = 0


func _process(_delta: float) -> void:
	if game_manager.current_dialogue_area == self and not overlaps_body(player):
		game_manager.end_dialogue()


# ----- STATE MANAGEMENT -----
func _on_area_entered(_area: Area2D) -> void:
	player.target_position = Vector2(global_position)
	game_manager.set_player_zooming_in()
	timer.start()
	game_manager.zoom_player(camera.asuka_zoom_value, camera.asuka_zoom_speed)
	await get_tree().create_timer(0.3).timeout
	eyes_sprite.frame = 1
	game_manager.start_dialogue(dialogue_resource, dialogue_start, self)


func _on_area_exited(_area: Area2D) -> void:
	if game_manager.current_dialogue_area == self:
		game_manager.end_dialogue()

	timer.stop()
	game_manager.zoom_player(camera.default_zoom_value, camera.reset_zoom_speed)
	await get_tree().create_timer(0.3).timeout
	eyes_sprite.frame = 0


#func _on_asuka_exit_area_mouse_exited() -> void:
	#if game_manager.current_dialogue_area == self:
		#game_manager.end_dialogue()
#
	#timer.stop()
	#game_manager.zoom_player(camera.default_zoom_value, camera.reset_zoom_speed)
	#await get_tree().create_timer(0.3).timeout
	#eyes_sprite.frame = 0
