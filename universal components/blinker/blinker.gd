extends Node

var blink_object: Node2D

@onready var blink_timer = $BlinkTimer
@onready var duration_timer = $DurationTimer

func _start_blinker(object, duration) -> void:
	blink_object = object
	duration_timer.wait_time = duration
	duration_timer.start()
	blink_timer.start()

func _on_blink_timer_timeout() -> void:
	blink_object.visible = !blink_object.visible

func _on_duration_timer_timeout() -> void:
	blink_timer.stop()
	blink_object.visible = true
