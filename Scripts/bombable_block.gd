extends StaticBody2D

func _on_area_check_bomb_area_entered(area: Area2D) -> void:
    if area.is_in_group("bomb"):
        destroy()
        

func destroy() -> void:
    $Sprite2D.visible = false
    $CollisionShape2D.set_deferred("disabled", true)
    $area_check_bomb/CollisionShape2D.set_deferred("disabled", true)
    [$Destroy1, $Destroy2, $Destroy3][randi() % 3].play()
