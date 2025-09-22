extends Area2D

func _ready() -> void:
	pass
	
func _on_body_entered(body: CharacterBody2D) -> void:
	if body.has_method("_respawn"):
		body._respawn()
