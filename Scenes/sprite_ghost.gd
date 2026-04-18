extends AnimatedSprite2D

var timer = 0.0
var origx = 0.0

func _process(delta: float) -> void:
    
    if visible:
        position.y -= delta*6
        position.x = origx + sin(timer*4)*3
        timer += delta
        # TODO - play "it is a mystery" theme
    else:
        origx = position.x
