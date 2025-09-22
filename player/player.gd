class_name Player extends CharacterBody2D

@export_subgroup("Nodes")
@export var camera: Camera2D
@export var gravity_comp: GravityComponent
@export var input_comp: InputComponent

var abilities: Array[Node] = []
var ability_registry: Dictionary = {}

var facing_dir: int = 0
var running_at_full: bool = false

var can_save: bool = false

@onready var saver_loader = %SaverLoader

func _ready() -> void:
	setup_ability_registry()
	print("Registry setup: ", ability_registry.keys())
	var move_comp = MoveComponent.new()
	_add_ability(move_comp)
	var ground_pound_comp = GroundPoundComponent.new()
	_add_ability(ground_pound_comp)
	
func _physics_process(delta: float) -> void:
	if can_save:
		if Input.is_action_just_pressed("up"):
			save()
			get_viewport().set_input_as_handled()
	gravity_comp.handle_gravity(self, delta)
	if input_comp.input_horizontal != 0:
		facing_dir = sign(input_comp.input_horizontal)
	
	for ability in abilities:
		if ability.has_method("tick"):
			ability.tick(self, delta)
	
	move_and_slide()
	
func get_facing_dir() -> int:
	return facing_dir
	
func setup_ability_registry():
	ability_registry["move"] = preload("res://player/move/move_comp.tscn")
	ability_registry["run"] = preload("res://player/run/run_comp.tscn")
	ability_registry["jump"] = preload("res://player/jump/jump_comp.tscn")
	ability_registry["double_jump"] = preload("res://player/double_jump/double_jump_comp.tscn")
	ability_registry["dash"] = preload("res://player/dash/dash_comp.tscn")
	
func _add_ability(ability: Node)-> void:
	if ability and not abilities.has(ability):
		abilities.append(ability)
		add_child(ability)
		ability.owner = self
		
func _remove_ability(ability: Node) -> void:
	if abilities.has(ability):
		abilities.erase(ability)
		remove_child(ability)
		
func restore_ability(ability_name: String):
	for existing_ability in abilities:
		print("Checking", existing_ability, "ability_name=", existing_ability.ability_name, "against", ability_name)
		if existing_ability.ability_name == ability_name:
			print("Already have ability:", ability_name)
			return
	if ability_registry.has(ability_name):
		var new_ability = ability_registry[ability_name].instantiate()
		_add_ability(new_ability)
		print("Restored: ", ability_name)
	else:
		print(ability_name, " is unknown")
		
func save() -> void:
	print("saving")
	saver_loader.save_game()

func _respawn() -> void:
	print("die here")
	saver_loader.reset_transient()
	
func reset_transient(saved_data: Array[SavedData]) -> void:
	for ability in abilities:
		remove_child(ability)
	abilities.clear()
	on_load_game(saved_data)
	
func on_save_game(saved_data: Array[SavedData]) -> void:
	var my_data = SavedData.new()
	my_data.position = global_position
	my_data.object_id = "player"
	my_data.object_type = "player"
	
	for ability in abilities:
		print("Saving ability:", ability.ability_name)
		my_data.abilities.append(ability.ability_name)
	
	saved_data.append(my_data)
	
func on_load_game(saved_data: Array[SavedData]) -> void:
	for my_data in saved_data:
		if my_data.object_id == "player" and my_data.object_type == "player":
			global_position = my_data.position
			for ability_name in my_data.abilities:
				restore_ability(ability_name)
			print("Player loaded with abilities: ", my_data.abilities)
			break
