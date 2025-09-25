class_name AnimationComponent extends Node

@export_subgroup("Nodes")
@export var animation_player: AnimationPlayer

var current_animation: String = ""
var is_locked: bool = false

func play(anim: String, force: bool = false, lock: bool = false) -> void:
	if is_locked and not force:
		return
	if animation_player.current_animation != anim:
		animation_player.play(anim)
		current_animation = anim
		is_locked = lock
		
func stop() -> void:
	animation_player.stop()
	current_animation = ""
	is_locked = false
	
func is_playing(anim: String) -> bool:
	return animation_player.current_animation == anim
	
func unlock() -> void:
	is_locked = false
