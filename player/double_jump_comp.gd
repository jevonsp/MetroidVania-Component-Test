class_name DoubleJumpCompontent extends Node

@export_subgroup("Settings")
@export var jump_velocity: float = -450.0
@export var running_jump_bonus: float = -100
@export var extra_jump_velocity: float = -400.0
@export var max_jumps: int = 2

@export_subgroup("Nodes")
@export var jump_buffer_timer: Timer
@export var coyote_timer: Timer

var input_comp: InputComponent
var player: Player

var is_going_up: bool = false
var is_jumping: bool = false
var last_frame_on_floor: bool = false

enum JumpState {FLOOR, JUMP, FALL, LAND}
var state: JumpState = JumpState.FLOOR

var jumps_done: int = 0

func _ready() -> void:
	player = get_parent()
	input_comp = player.input_comp
	for ability in player.abilities:
		if ability is JumpComponent:
			player._remove_ability(ability)
	
func tick(body: CharacterBody2D, _delta: float) -> void:
	var want_to_jump = input_comp.jump_pressed or \
	(not jump_buffer_timer.is_stopped() and body.is_on_floor())
	var jump_released = Input.is_action_just_released("jump")

	handle_jump(body, want_to_jump, jump_released)

func has_just_landed(body: CharacterBody2D) -> bool:
	var landed = body.is_on_floor() and jumps_done > 0
	if landed:
		jumps_done = 0
	return landed

func is_allowed_to_jump(body: CharacterBody2D, want_to_jump: bool) -> bool:
	if not want_to_jump:
		return false
	if body.is_on_floor() or not coyote_timer.is_stopped():
		return true
	return jumps_done < max_jumps

func handle_jump(body: CharacterBody2D, want_to_jump: bool, jump_released: bool) -> void:
	if has_just_landed(body):
		is_jumping = true

	if is_allowed_to_jump(body, want_to_jump):
		jump(body)

	handle_coyote_time(body)
	handle_jump_buffer(body, want_to_jump)
	handle_variable_jump_height(body, jump_released)

	is_going_up = body.velocity.y < 0 and not body.is_on_floor()
	last_frame_on_floor = body.is_on_floor()

	if body.is_on_floor() and not is_going_up and not want_to_jump:
		is_jumping = false

func handle_jump_buffer(body: CharacterBody2D, want_to_jump: bool) -> void:
	if want_to_jump and not body.is_on_floor():
		jump_buffer_timer.start()

	if body.is_on_floor() and not jump_buffer_timer.is_stopped():
		jump(body)

func handle_variable_jump_height(body: CharacterBody2D, jump_released: bool) -> void:
	if jump_released and is_going_up:
		body.velocity.y = 0 

func has_just_stepped_off_ledge(body: CharacterBody2D) -> bool:
	var not_on_floor = not body.is_on_floor()
	var was_on_floor = last_frame_on_floor
	var not_jumping = not is_jumping

	return not_on_floor and was_on_floor and not_jumping

func handle_coyote_time(body: CharacterBody2D) -> void:
	if has_just_stepped_off_ledge(body):
		coyote_timer.start()

	if not coyote_timer.is_stopped() and not is_jumping:
		body.velocity.y = 0

func jump(body: CharacterBody2D) -> void:
	var base_velocity: float
	var true_jump_velocity: float
	
	if body.is_on_floor():
		base_velocity = jump_velocity
	else:
		base_velocity = extra_jump_velocity
	
	if player.running_at_full == true:
		true_jump_velocity = base_velocity + running_jump_bonus
	else:
		true_jump_velocity = base_velocity
	
	body.velocity.y = true_jump_velocity
	jumps_done += 1
	jump_buffer_timer.stop()
	is_jumping = true
	coyote_timer.stop()
