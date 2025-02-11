@tool
extends Node2D


@onready var water: DynamicWater2D = $Water


func _process(_delta: float) -> void:
	var mouse_coords := water.get_global_mouse_position()
	# apply 128 units of downwards force on mouse position in a 48 unit radius
	water.apply_force(mouse_coords, 128.0 * Vector2.DOWN, 48.0)
