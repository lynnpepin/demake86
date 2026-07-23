extends AnimatedSprite2D

@export var time: float = 0.0



func _physics_process(delta: float) -> void:
    time += delta
    offset.x = sin(time * 3 * PI)
    offset.y = cos(time * 12 * PI)
