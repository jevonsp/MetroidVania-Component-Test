class_name Player extends CharacterBody2D

@export_subgroup("Nodes")
@export var camera: Camera2D
@export var gravity_comp: GravityComponent
@export var input_comp: InputComponent
@export var move_comp_scene: PackedScene

var abilities: Array[Node] = []

var facing_dir: int = 0
var running_at_full: bool = false

var can_save: bool = false

@onready var saver_loader = %SaverLoader

func _ready() -> void:
	var move_comp = MoveComponent.new()
	_add_ability(move_comp)
	
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
	
func _add_ability(ability: Node)-> void:
	if ability and not abilities.has(ability):
		abilities.append(ability)
		add_child(ability)
		ability.owner = self
		
func _remove_ability(ability: Node) -> void:
	if abilities.has(ability):
		abilities.erase(ability)
		remove_child(ability)
	
func save() -> void:
	saver_loader.save_game()

func _respawn() -> void:
	saver_loader.load_game()
	
func on_save_game(saved_data: Array[SavedData]) -> void:
	var my_data = SavedData.new()
	my_data.position = global_position
	
	saved_data.append(my_data)
	
func on_load_game(saved_data: Array[SavedData]) -> void:
	pass
