class_name PatrolComponent extends AIComponent

@export var patrol_distance: float = 100
var start_x: float
var dir: int = 1

func _ready() -> void:
	start_x = owner.global_position.x
	
func should_run() -> bool:
	return true
	
func get_intent() -> Dictionary:
	var offset = owner.global_position.x - start_x
	
	if offset >= patrol_distance:
		dir = -1
	elif offset <= -patrol_distance:
		dir = 1
	return {"move_dir": dir}
