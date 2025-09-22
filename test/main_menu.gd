extends Node2D

signal load_pressed
signal erase_save_pressed

@export_subgroup("Nodes")
@export var camera: Camera2D

func _ready():
	camera.make_current()
	
func _on_load_save_pressed() -> void:
	load_pressed.emit()

func _on_erase_save_pressed() -> void:
	erase_save_pressed.emit()
