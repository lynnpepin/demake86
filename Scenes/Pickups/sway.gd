extends AnimatedSprite2D

var timer: float = 0.0

var picked: bool = false

@onready var speed: float = randf_range(0.75, 1.5)

func _process(delta: float) -> void:
    if !picked:
        timer += delta * speed
        position.y = abs((fmod(floor(timer), 4) - 2))
