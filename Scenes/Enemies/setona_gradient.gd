extends Sprite2D

var radius = 256.0

func _process(delta: float) -> void:
    
    radius -= delta
    #material.set_shader_parameter("radius", radius)
