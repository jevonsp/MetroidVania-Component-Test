class_name MoveComponent extends Node

@export var ability_name: String = "move"
@export_subgroup("Settings")
@export var speed: float = 200
@export var ground_accel_speed: float = 6.0
@export var ground_decel_speed:float = 8.0
@export var ground_turning_speed: float = 20.0
@export var air_accel_speed: float = 10.0
@export var air_decel_speed: float = 3.0

@export_subgroup("Nodes")
var input_comp: InputComponent

@export var left_points: Array[Vector2] = [Vector2(-16,0), Vector2(-3,-16), Vector2(-3, 16)]
@export var right_points: Array[Vector2] = [Vector2(16,0), Vector2(3, -16), Vector2(3, 16)]

func _ready() -> void:
	input_comp = get_parent().get_node("InputComp")

func tick(body: CharacterBody2D, _delta: float) -> void:
	var velocity_change_speed := 0.0
	var direction = input_comp.input_horizontal
	if body.is_on_floor():
		velocity_change_speed = ground_accel_speed if direction != 0 else ground_decel_speed
	else:
		velocity_change_speed = air_accel_speed if direction != 0 else air_decel_speed
	
	if body.is_on_floor():
		if sign(body.velocity.x) != sign(input_comp.input_horizontal):
			velocity_change_speed = ground_turning_speed
	
	body.velocity.x = move_toward(body.velocity.x, direction * speed, velocity_change_speed)
