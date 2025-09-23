class_name InputComponent extends Node

var input_horizontal: float = 0.0
var jump_pressed: bool = false
var dash_pressed: bool = false
var run_pressed: bool = false
var down_pressed: bool = false

func _physics_process(_delta: float) -> void:
	input_horizontal = Input.get_axis("left", "right")
	jump_pressed = Input.is_action_just_pressed("jump")
	dash_pressed = Input.is_action_pressed("dash")
	run_pressed = Input.is_action_pressed("run")
	down_pressed = Input.is_action_pressed("down")
