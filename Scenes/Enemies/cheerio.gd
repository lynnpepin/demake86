extends RigidBody2D



var velocity: float = 16.0

var direction: Vector2 = Vector2(-1, 0).normalized()

var collided: bool = false

var deltimer = 0.0

func _physics_process(delta: float) -> void:
    if !collided:
        var col = move_and_collide(direction * velocity * delta)
        if col:
            collided = true
            $AnimatedSprite2D.visible = false
            $CollisionShape2D.set_deferred("disabled", true)
            $CPUParticles2D.emitting = true
            $CheerioDink.play()

func _process(delta: float) -> void:
    if collided:
        deltimer += delta
        if deltimer > 4.0:
            queue_free()
