extends Area2D

@export var dialogue_resource: Resource = preload("res://dialogues/asuka.dialogue")
@export var dialogue_start: String = "asuka_intro"

@onready var timer: Timer = $AsukaTimer
@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var eyes_sprite: AnimatedSprite2D = $EyesSprite
@onready var game_manager: Node = $"../GameManager"

# ----- INITIALIZATION AND PHYSICS -----
func _ready() -> void:
	eyes_sprite.frame = 0
	
func _process(_delta: float) -> void:
	if game_manager.current_dialogue_area == self and not overlaps_body(game_manager.player):
		game_manager.end_dialogue()

# ----- STATE MANAGEMENT -----
func _on_area_entered(area: Area2D) -> void:
		game_manager.set_player_state(game_manager.PlayerState.ZOOMING_IN)
		game_manager.player.start_zoom(global_position)
		
		timer.start()
		
		camera.set_camera_zoom(camera.asuka_zoom_value, camera.asuka_zoom_speed)
		await get_tree().create_timer(0.3).timeout
		eyes_sprite.frame = 1
		
		game_manager.start_dialogue(dialogue_resource, dialogue_start, self)

func _on_area_exited(area: Area2D) -> void:
		if game_manager.current_dialogue_area == self:
			game_manager.end_dialogue()
		
		game_manager.set_player_state(game_manager.PlayerState.ZOOMING_OUT)
		game_manager.player.end_zoom()
		
		timer.stop()
		camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
		await get_tree().create_timer(0.3).timeout
		eyes_sprite.frame = 0
