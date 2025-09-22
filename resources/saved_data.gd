class_name SavedData extends Resource

# Object ID
@export var object_id: String = ""
@export var object_type: String = ""

# Player data
@export var position: Vector2 = Vector2.ZERO
@export var abilities: Array[String] = []

# Collectables
@export var pickup_state: bool = false
