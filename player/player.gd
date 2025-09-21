class_name Player extends CharacterBody2D

@export_subgroup("Nodes")
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var move_component: MoveComponent
@export var jump_component: JumpComponent

var abilities: Array[Node] = []

var facing_dir: int = 0

func _ready() -> void:
	_add_ability(jump_component)

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self, delta)
	move_component.handle_horizontal_movement(self, input_component.input_horizontal)
	if input_component.input_horizontal != 0:
		facing_dir = sign(input_component.input_horizontal)
	
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
