class_name HealthComponent extends Node

const invincibility_duration: float = 1.0

@export_subgroup("Settings")
@export var max_hitpoints: int = 3

var hitpoints: int = 3

var hurtbox: Area2D
var blinker: Node

func _ready() -> void:
	reset_hitpoints()
	hurtbox = get_parent().get_node("Hurtbox")
	blinker = get_parent().get_node("Blinker")
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area is Hitbox and not hurtbox.is_invincible:
		var hitbox := area as Hitbox
		Debug.debug_print("hurtbox hit by: " + hitbox.name)
		blinker._start_blinker(get_parent(), invincibility_duration)
		hurtbox._start_invincibility(invincibility_duration)
		hurtbox._flash_white()
		hitpoints -= hitbox.damage
		
		if hitpoints <= 0 and get_parent().has_method("_die"):
			get_parent()._die()
			reset_hitpoints()
			
func reset_hitpoints():
	hitpoints = max_hitpoints
