extends AnimationPlayer

func _physics_process(delta: float) -> void:
    if (
        Input.is_action_pressed("pad_x") 
        or Input.is_action_pressed("pad_a")
    ):
        seek(20)
        #play("new_animation", 0.0, true)
