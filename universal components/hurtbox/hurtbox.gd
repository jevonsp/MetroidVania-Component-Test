class_name Hurtbox extends Area2D

const whiten_duration = 0.15
@export_subgroup("Hurtbox Settings")
@export var team: int = 0 
@export_subgroup("Shader Settings")
@export var whiten_material: ShaderMaterial

var is_invincible: bool = false

var _flash_timer

@onready var collision_shape = $CollisionShape2D

func _ready() -> void:
	_flash_timer = Timer.new()
	_flash_timer.one_shot = true
	add_child(_flash_timer)
	if team == 0:
		collision_mask = 3
	elif team == 1:
		collision_mask = 2

func _start_invincibility(invincibilty_duration: float) -> void:
	if invincibilty_duration > 0:
		is_invincible = true
		collision_shape.set_deferred("disabled", true)
		await get_tree().create_timer(invincibilty_duration).timeout
		collision_shape.set_deferred("disabled", false)
		is_invincible = false

func _flash_white() -> void:
	# Cancel any previous flash
	if _flash_timer.is_stopped() == false:
		_flash_timer.stop()
		whiten_material.set_shader_parameter("whiten", false)
	# Turn on whiten
	whiten_material.set_shader_parameter("whiten", true)
	# Start timer
	_flash_timer.start(whiten_duration)
	# Wait for timer to finish safely
	await _flash_timer.timeout
	whiten_material.set_shader_parameter("whiten", false)
