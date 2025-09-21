extends CollisionPolygon2D

func _ready() -> void:
	var points = [
		Vector2(-16, 18),  # bottom-left
		Vector2(16, 18),   # bottom-right
		Vector2(16, 16),   # start top-right curve
		Vector2(12, 10),   # curve point
		Vector2(8, 4),     # curve point
		Vector2(4, 0),     # curve point
		Vector2(0, -2),    # top-center
		Vector2(-4, 0),    # curve point
		Vector2(-8, 4),    # curve point
		Vector2(-12, 10),  # curve point
		Vector2(-16, 16)]   # start top-left curve
	polygon = points
