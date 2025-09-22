class_name Pickup extends Node2D

@export_subgroup("Pickup Info")
@export var ability_scene: PackedScene
@export var ability_name: String = ""

var is_collected: bool = false

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.has_method("_add_ability"):
		body._add_ability(ability_scene.instantiate())
		is_collected = true
		visible = false
		disconnect("body_entered", Callable(self, "_on_body_entered"))
		
func on_save_game(saved_data: Array[SavedData]):
	var my_data = SavedData.new()
	my_data.pickup_state = is_collected
	
	saved_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()
	
func on_load_game(saved_data: Array[SavedData]) -> void:
	pass
