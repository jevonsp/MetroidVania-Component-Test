class_name SaverLoader extends Node

@export var save_path: String = "user://savedgame.tres"
@onready var player = %Player

func save_game():
	var saved_game: SavedGame = SavedGame.new()
	
	var saved_data: Array[SavedData] = []
	get_tree().call_group("can_save", "on_save_game", saved_data)
	saved_game.saved_data = saved_data
	
	ResourceSaver.save(saved_game, save_path)
	
	print("saved game")
	
func load_game():
	if not FileAccess.file_exists(save_path):
		print("no save file")
		return
	var saved_game: SavedGame = load(save_path)
	if not saved_game:
		print("failed to load file")
		return
	print("loading file")
	
	get_tree().call_group("can_save", "on_load_game", saved_game.saved_data)

func reset_transient():
	var saved_game: SavedGame = load(save_path)
	get_tree().call_group("can_save", "reset_transient", saved_game.saved_data)
