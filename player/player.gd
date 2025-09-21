class_name Player extends CharacterBody2D

@export_subgroup("Nodes")
@export var gravity_comp: GravityComponent
@export var input_comp: InputComponent

var abilities: Array[Node] = []

var facing_dir: int = 0
var running_at_full: bool = false

func _ready() -> void:
	var move_comp = MoveComponent.new()
	_add_ability(move_comp)
	print(abilities)
	
func _physics_process(delta: float) -> void:
	gravity_comp.handle_gravity(self, delta)
	if input_comp.input_horizontal != 0:
		facing_dir = sign(input_comp.input_horizontal)
	
	for ability in abilities:
		if ability.has_method("tick"):
			ability.tick(self, delta)
	
	move_and_slide()
	
func _add_ability(ability: Node) -> void:
	if ability and not abilities.has(ability):
		abilities.append(ability)
		add_child(ability)
		ability.owner = self
		
func _remove_ability(ability: Node) -> void:
	if abilities.has(ability):
		abilities.erase(ability)
		remove_child(ability)

func get_facing_dir() -> int:
	return facing_dir
