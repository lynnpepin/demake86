extends AnimatedSprite2D

@onready var orig_y = global_position.y
@onready var timer = 0.0
var velocity = -72
var gravity = 196

func _process(delta: float) -> void:
    if visible:
        timer += delta
        if timer > 0.5:
            global_position.y += velocity * delta
            velocity += gravity * delta
