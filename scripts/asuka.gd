extends Area2D

@onready var timer: Timer = $AsukaTimer
@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var eyes_sprite: AnimatedSprite2D = $EyesSprite
@onready var game_manager: Node2D = %GameManager
@onready var player: CharacterBody2D = %Player




func _ready() -> void:
	eyes_sprite.frame = 0


func _on_area_entered(_area: Area2D) -> void:
    enter_asuka()
    

func _on_area_exited(_area: Area2D) -> void:
    exit_asuka()
    
    
func enter_asuka() -> void:
    player.state = "asuka_zooming_in"
	print(player.state)
	timer.start()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	game_manager.handle_timeline("asuka")
    camera.set_camera_zoom(camera.asuka_zoom_value, camera.asuka_zoom_speed)
	
    await get_tree().create_timer(0.3).timeout
	eyes_sprite.frame = 1
	print("Entered Asuka area: ", game_manager.timelines)


func exit_asuka() -> void:
    player.state = "free"
	print(player.state)
	timer.stop()
	game_manager.handle_timeline("asuka", true)
	if Dialogic.Styles.get_layout_node():
		Dialogic.Styles.get_layout_node().hide()
    camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
	await get_tree().create_timer(0.3).timeout
	eyes_sprite.frame = 0
	print("Exited Asuka area: ", game_manager.timelines)