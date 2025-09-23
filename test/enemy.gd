extends Node2D

func _die():
	print("enemy die here")
	queue_free()
