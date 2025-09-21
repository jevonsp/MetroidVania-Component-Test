class_name DashComponent extends Node

@export_subgroup("Settings")
@export var dash_speed: float = 400
@export var dash_duration: float = 0.3
@export var max_air_dashes: float = 1

@export_subgroup("Nodes")
@export var dash_cooldown: Timer

var player: Player
var input_comp: InputComponent
var move_comp: MoveComponent

var is_dashing: bool = false
var dash_time_left: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO
var air_dashes_done: int = 0

func _ready() -> void:
	player = get_parent()
	input_comp = player.get_node("InputComp")
	
	for ability in player.abilities:
		if ability is MoveComponent:
			move_comp = ability

func tick(body: CharacterBody2D, delta) -> void:
	handle_input(body)
	handle_dash(body, delta)
	reset_air_dashes(body)
		
func handle_input(body: CharacterBody2D) -> void:
	if not dash_cooldown.is_stopped():
		return
		
	if input_comp.dash_pressed:
		if body.is_on_floor() or air_dashes_done < max_air_dashes:
			start_dash(body)
			print("started dash")
		
func start_dash(body: CharacterBody2D) -> void:
	is_dashing = true
	dash_time_left = dash_duration
	
	var horizontal_input = sign(input_comp.input_horizontal)
	if horizontal_input == 0:
		horizontal_input = player.get_facing_dir()
		
	dash_direction = Vector2(horizontal_input, 0)
	
	if not body.is_on_floor():
		air_dashes_done += 1
		
	dash_cooldown.start()
	
func handle_dash(body: CharacterBody2D, delta: float) -> void:
	var max_speed: float = 500
	if is_dashing:
		body.velocity.x += dash_direction.x * dash_speed
		body.velocity.y = 0
		
		dash_time_left -= delta
		if dash_time_left <= 0:
			is_dashing = false
		if not input_comp.dash_pressed:
			is_dashing = false
			
	body.velocity.x = clamp(body.velocity.x, -max_speed, max_speed)
	
func reset_air_dashes(body: CharacterBody2D) -> void:
	if body.is_on_floor():
		air_dashes_done = 0
		
