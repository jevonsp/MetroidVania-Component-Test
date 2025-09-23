class_name Hitbox extends Area2D

@export var damage: int = 1
@export var team: int = 0

func _ready() -> void:
	if team == 0:
		collision_layer = 1
		collision_mask = 2
	elif team == 1:
		collision_layer = 2
		collision_mask = 1
