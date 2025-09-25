class_name GroundPoundComponent extends Node

signal ground_pound_started
signal ground_pound_ended

@export var ability_name: String = "ground_pound"
@export_subgroup("Settings")
@export var vert_speed: float = 600.0
@export var horiz_decel_speed: float = 400.0

var player: Player
var input_comp: InputComponent

var is_jumping: bool = false
var is_ground_pounding: bool = false

@onready var hitbox: Hitbox = $Hitbox

func _ready() -> void:
	player = get_parent()
	input_comp = player.input_comp
	ground_pound_started.connect(Callable(player, "_on_ground_pound_started"))
	ground_pound_ended.connect(Callable(player, "_on_ground_pound_ended"))
	
func tick(body: CharacterBody2D, _delta: float) -> void:
	update_jumping_state(body)
	
	if (is_jumping) and (input_comp.down_pressed):
		ground_pound(body)
		
	if is_ground_pounding:
		var decel_speed := horiz_decel_speed
		body.velocity.x = move_toward(body.velocity.x, 0.0, decel_speed)
		body.velocity.y = vert_speed
		hitbox.position = player.global_position + Vector2(0, 16)
		
func update_jumping_state(body: CharacterBody2D):
	if body.is_on_floor():
		if is_ground_pounding:
			is_ground_pounding = false
			ground_pound_ended.emit()
		hitbox.monitoring = false
		is_jumping = false
	else:
		is_jumping = true
	
func ground_pound(body) -> void:
	if not is_ground_pounding:
		is_ground_pounding = true
		ground_pound_started.emit()
		hitbox.global_position = body.global_position + Vector2(0, 16)
		hitbox.monitoring = true
