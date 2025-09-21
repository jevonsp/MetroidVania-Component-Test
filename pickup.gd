class_name Pickup extends Node2D

@export var ability_scene: PackedScene
	
func _on_body_entered(body: CharacterBody2D) -> void:
	if body.has_method("_add_ability"):
		print("adding ability")
		var new_ability = ability_scene.instantiate()
		body._add_ability(new_ability)
		queue_free()
