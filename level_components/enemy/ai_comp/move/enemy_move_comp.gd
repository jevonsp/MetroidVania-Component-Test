class_name EnemyMoveComponent extends Node

@export var speed: float = 100
var direction: int = 0

func tick(enemy: CharacterBody2D, intent: Dictionary, _delta: float) -> void:
	if intent.has("move_dir"):
		direction = intent["move_dir"]
	enemy.velocity.x = direction * speed 
