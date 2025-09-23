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
	print("GroundPound ready: hitbox =", hitbox.name, 
		" team =", hitbox.team, 
		" layer =", hitbox.collision_layer, 
		" mask =", hitbox.collision_mask)
	if not ground_pound_ended.is_connected(Callable(get_parent(), "_on_ground_pound_ended")):
		ground_pound_ended.connect(Callable(get_parent(), "_on_ground_pound_ended"))
	
func tick(body: CharacterBody2D, _delta: float) -> void:
	update_jumping_state(body)
	
	if (is_jumping) and (input_comp.down_pressed):
		is_ground_pounding = true
		ground_pound_started.emit()
		hitbox.global_position = body.global_position + Vector2(0, 16)
		hitbox.monitoring = true
		var decel_speed := horiz_decel_speed
		body.velocity.x = move_toward(body.velocity.x, 0.0, decel_speed)
		body.velocity.y = vert_speed
		
	if is_ground_pounding and player.is_on_floor():
		is_ground_pounding = false
		ground_pound_ended.emit()

func update_jumping_state(body: CharacterBody2D):
	if body.is_on_floor():
		hitbox.monitoring = false
		is_jumping = false
	else:
		is_jumping = true
	
