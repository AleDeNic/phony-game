extends CharacterBody2D

@onready var game_manager: Node = $"../GameManager"

@export var default_speed: float = 65.0
@export var transition_speed: float = 5.0
@export var zoom_speed: float = 400.0
@export var exit_speed: float = 12.0
@export var dead_zone_radius: float = 1.0

var current_speed: float   = default_speed
var target_speed: float
var viewport: Viewport
var target_position: Vector2
var last_movement: Vector2 = Vector2.ZERO
var stopping: bool         = false


# ----- INITIALIZATION -----
func _ready() -> void:
    viewport = get_viewport()
    set_free()
    reset_mouse_to_center()


func _physics_process(delta: float) -> void:
    if not viewport:
        setup_viewport()
        return

    match game_manager.get_player_state():
        GameManager.PlayerState.FREE, GameManager.PlayerState.ZOOMING_OUT:
            handle_movement(delta)
        GameManager.PlayerState.ZOOMING_IN:
            handle_zooming_in(delta)
        GameManager.PlayerState.IN_DIALOGUE:
            velocity = Vector2.ZERO

    move_and_slide()


# ----- VIEWPORT CHECK. IT MAY BE NULL DURING INITIALIZATION -----
func setup_viewport() -> void:
    viewport = get_viewport()
    if viewport:
        reset_mouse_to_center()


# ------------- INPUT & MOVEMENT -----------------
func handle_movement(delta: float) -> void:
    var movement_vector: Vector2 = get_movement_input()

    if game_manager.is_player_zooming_out():
        current_speed = exit_speed
        target_speed = default_speed
    else:
        target_speed = default_speed

    reset_mouse_to_center()
    current_speed = lerp(current_speed, target_speed, delta * transition_speed)
    velocity = movement_vector * current_speed


func get_movement_input() -> Vector2:
    if not viewport:
        return Vector2.ZERO
    var mouse_pos: Vector2       = viewport.get_mouse_position()
    var center: Vector2          = viewport.get_visible_rect().size / 2
    var movement_vector: Vector2 = mouse_pos - center
    return Vector2.ZERO if movement_vector.length() < dead_zone_radius else movement_vector


func reset_mouse_to_center() -> void:
    if viewport:
        viewport.warp_mouse(viewport.get_visible_rect().size / 2)


# ----- UTILS -----
func handle_zooming_in(delta: float) -> void:
    if target_position:
        var movement_vector: Vector2 = (target_position - global_position).normalized()
        target_speed = zoom_speed if global_position.distance_to(target_position) >= 30.0 else 0.0
        current_speed = lerp(current_speed, target_speed, delta * transition_speed)
        velocity = movement_vector * current_speed
    else:
        velocity = Vector2.ZERO


func zoom_to(zoom_value: Vector2, zoom_speed: float) -> void:
    $Camera2D.set_camera_zoom(zoom_value, zoom_speed)


func set_free() -> void:
    reset_mouse_to_center()
    stopping = false
    last_movement = Vector2.ZERO
