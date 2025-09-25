class_name Enemy extends CharacterBody2D


@export_subgroup("Settings")

@export_subgroup("Nodes")
@export var health_comp: HealthComponent
@export var hurtbox: Hurtbox
@export var blinker: Node
@export var gravity_comp: GravityComponent
@export var animation_comp: AnimationComponent
@export var abilities_node: Node
@export var ai_node: Node

var abilities: Array[Node] = []
var ai_modules: Array[Node] = []

func _ready() -> void:
	for ability in abilities_node.get_children():
		abilities.append(ability)
		ability.owner = self
	for ai in ai_node.get_children():
		ai_modules.append(ai)
		ai.owner = self
		
func _physics_process(delta: float) -> void:
	gravity_comp.handle_gravity(self, delta)
	
	var merged_intent := {}
	for ai in ai_modules:
		if ai.should_run():
			var intent = ai.get_intent()
			# Order in scene tree matters, last ran has prio
			for key in intent.keys():
				merged_intent[key] = intent[key]
	
	for ability in abilities:
		if ability.has_method("tick"):
			ability.tick(self, merged_intent, delta)
	
	move_and_slide()
	
func _die():
	print("enemy hitd")
	queue_free()
