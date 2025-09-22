class_name Pickup extends Node2D

@export_subgroup("Pickup Info")
@export var ability_scene: PackedScene
@export var pickup_id: String = ""

var is_collected: bool = false
var runtime_collected: bool = false

func _ready() -> void:
	if not is_in_group("can_save"):
		add_to_group("can_save")

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.has_method("_add_ability"):
		body._add_ability(ability_scene.instantiate())
		visible = false
		runtime_collected = true
		if is_connected("body_entered", Callable(self, "_on_body_entered")):
			disconnect("body_entered", Callable(self, "_on_body_entered"))
		
func on_save_game(saved_data: Array[SavedData]):
	var my_data = SavedData.new()
	my_data.object_id = pickup_id
	my_data.object_type = "pickup"
	if runtime_collected:
		is_collected = true
	my_data.pickup_state = is_collected
	#region Debug
	Debug.debug_print("Saving pickup: " + pickup_id + " collected: " + str(is_collected))
	#endregion
	saved_data.append(my_data)

func on_load_game(saved_data: Array[SavedData]) -> void:
	Debug.debug_print("Pickup checking for ID: '" + pickup_id + "'")
	for my_data in saved_data:
		#region Debug
		Debug.debug_print("Found pickup data with ID: '" + my_data.object_id + "' collected: " + str(my_data.pickup_state))
		#endregion
		if my_data.object_id == pickup_id and my_data.object_type == "pickup":
			is_collected = my_data.pickup_state
			#region Debug
			Debug.debug_print("Match found! Pickup " + pickup_id + "was collected: " + str(is_collected))
			#endregion
			if is_collected:
				#region Debug
				Debug.debug_print("Removing pickup: " + pickup_id)
				#endregion
				if is_inside_tree():
					get_parent().remove_child(self)
				queue_free()

func reset_transient(_saved_data: Array[SavedData]) -> void:
	if not is_collected:
		runtime_collected = false
		visible = true
		if not is_connected("body_entered", Callable(self, "_on_body_entered")):
			connect("body_entered", Callable(self, "_on_body_entered"))
