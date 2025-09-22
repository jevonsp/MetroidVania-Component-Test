class_name SavePoint extends Area2D

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.has_method("save"):
		body.can_save = true
		print("can_save = ", body.can_save)
		
func _on_body_exited(body: Node2D) -> void:
	if body.has_method("save"):
		body.can_save = false
		print("can_save = ", body.can_save)
