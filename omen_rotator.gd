extends Node2D

func _physics_process(delta: float) -> void:
    rotate(delta * PI / 60.0)
    print($Omen.global_position)
