extends Node2D

@export var player: Node2D

var is_aware: bool = false

func aware():
    if !is_aware:
        is_aware = true
        $Sprite2D_Reagan.flip_h = 1
        $Sprite2D_Reagan.offset.y -= 4
        $Sprite2D_Reagan.offset.x += 3


func _on_area_2d_aware_area_entered(area: Area2D) -> void:
    aware()
    pass # Replace with function body.
