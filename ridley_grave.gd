extends StaticBody2D

func _enter_tree() -> void:
    activate()
    pass

func activate():
    $Sprite2D.visible = true
    $CollisionShape2D.disabled = false
    $AudioStreamPlayer2D.play()
