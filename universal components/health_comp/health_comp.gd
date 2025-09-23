class_name HealthComponent extends Node

const invincibility_duration: float = 1.0

@export_subgroup("Settings")
@export var hitpoints: int = 3

var hurtbox: Area2D
var blinker: Node

func _ready() -> void:
	hurtbox = get_parent().get_node("Hurtbox")
	blinker = get_parent().get_node("Blinker")
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if not hurtbox.is_invincible:
		Debug.debug_print("hurtbox area: " + area.name + "entered")
		blinker._start_blinker(get_parent(), invincibility_duration)
		hurtbox._start_invincibility(invincibility_duration)
		hitpoints -= 1
	if hitpoints == 0:
		if get_parent().has_method("_die"):
			get_parent()._die()
