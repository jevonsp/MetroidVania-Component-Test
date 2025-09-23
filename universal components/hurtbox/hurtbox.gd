class_name Hurtbox extends Area2D

const whiten_duration = 0.15
@export var whiten_material: ShaderMaterial

var is_invincible: bool = false

@onready var collision_shape = $CollisionShape2D

func _start_invincibility(invincibilty_duration: float) -> void:
	is_invincible = true
	collision_shape.set_deferred("disabled", true)
	await get_tree().create_timer(invincibilty_duration).timeout
	collision_shape.set_deferred("disabled", false)
	is_invincible = false

func _flash_white() -> void:
	whiten_material.set_shader_parameter("whiten", true)
	await get_tree().create_timer(whiten_duration).timeout
	whiten_material.set_shader_parameter("whiten", false)
