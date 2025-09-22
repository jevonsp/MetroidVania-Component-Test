class_name RunComponent extends Node

@export var ability_name: String = "RunComponent"
@export_subgroup("Settings")
@export var max_speed: float = 200
@export var max_run_speed: float = 350
@export var run_speed_time: float = .5
@export var ground_accel_speed: float = 6.0
@export var ground_decel_speed:float = 8.0
@export var air_accel_speed: float = 10.0
@export var air_decel_speed: float = 3.0

var input_comp: InputComponent
var player: Player

var is_running: bool = true

var run_lerp_progress: float = 0.0
var current_speed: float = 0.0

func _ready() -> void:
	player = get_parent()
	input_comp = player.input_comp
	for ability in player.abilities:
		if ability is MoveComponent:
			player._remove_ability(ability)
			
func tick(body: CharacterBody2D, delta: float) -> void:
	var velocity_change_speed := 0.0
	var direction = input_comp.input_horizontal
	if input_comp.run_pressed and direction != 0:
		is_running = true
		run_lerp_progress = min(run_lerp_progress + (delta/run_speed_time), 1.0)
	else:
		is_running = false
		run_lerp_progress = max(run_lerp_progress - (delta / run_speed_time), 0.0)
		
	current_speed = lerp(max_speed, max_run_speed, run_lerp_progress)
	
	if body.is_on_floor():
		velocity_change_speed = ground_accel_speed if direction != 0 else ground_decel_speed
	else:
		velocity_change_speed = air_accel_speed if direction != 0 else air_decel_speed
		
	body.velocity.x = move_toward(body.velocity.x, direction * current_speed, velocity_change_speed)
	if current_speed == max_run_speed:
		player.running_at_full = true
	else:
		player.running_at_full = false
