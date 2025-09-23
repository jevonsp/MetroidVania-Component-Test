class_name Hitbox extends Area2D

@export_subgroup("Shape Settings")
@export var shape_resource: Shape2D
@export_subgroup("Hitbox Settings")
@export var damage: int = 1
@export var team: int = 0

func _ready() -> void:
	if team == 0:
		collision_layer = 1
	elif team == 1:
		collision_layer = 2
	call_deferred("set_shape")
	
func set_shape() -> void:
	if shape_resource:
		var coll_shape := CollisionShape2D.new()
		coll_shape.shape = shape_resource
		add_child(coll_shape)
