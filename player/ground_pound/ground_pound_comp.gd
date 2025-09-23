class_name GroundPoundComponent extends Node

@export var ability_name: String = "ground_pound"
@export_subgroup("Settings")

var player: Player
var input_comp: InputComponent

var is_jumping: bool = false

func _ready() -> void:
	player = get_parent()
	input_comp = player.input_comp

func tick(body: CharacterBody2D, _delta: float) -> void:
	update_jumping_state(body)
	
	if (is_jumping) and (input_comp.down_pressed):
		var decel_speed := 400.0
		body.velocity.x = move_toward(body.velocity.x, 0.0, decel_speed)
		body.velocity.y = 600
	
func update_jumping_state(body: CharacterBody2D):
	if body.is_on_floor():
		is_jumping = false
	else:
		is_jumping = true
	
