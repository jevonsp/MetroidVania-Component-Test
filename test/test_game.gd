extends Node2D

@export_subgroup("Nodes")
@export var menu: Node2D
@export var world: Node2D

func _ready() -> void:
	world.visible = false
	for child in world.get_children():
		child.set_process_input(false)

func show_world():
	world.visible = true
	for child in world.get_children():
		child.set_process_input(true)
	
func hide_menu():
	menu.visible = false
	set_process_input(false)

func _on_main_menu_load_pressed() -> void:
	world.saver_loader.load_game()
	world.player.camera.make_current()
	show_world()
	hide_menu()
	
func _on_main_menu_erase_save_pressed() -> void:
	pass # Replace with function body.
	
