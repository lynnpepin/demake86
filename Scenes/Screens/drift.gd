extends Node2D


@export var hspeed: float = 1.0
@export var vspeed: float = 1.0

func _process(delta: float) -> void:
    position.x += hspeed * delta
    position.y += vspeed * delta
