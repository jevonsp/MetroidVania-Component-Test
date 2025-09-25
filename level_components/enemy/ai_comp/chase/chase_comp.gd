class_name ChaseComponent extends AIComponent

@export var detection_range: float = 150
var player: CharacterBody2D

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]
	
func should_run() -> bool:
	return player and owner.global_position.distance_to(player.global_position) < detection_range
	
func get_intent() -> Dictionary:
	if player:
		return {"move_dir": sign(player.global_position.x - owner.global_position.x)}
	return {}
