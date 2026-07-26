extends EnemyClass

var time: float = 0.0
var radius: float = 128.0

@export var tracking: Node2D
@export var tracking_distance: float = 512.0

func _physics_process(delta: float) -> void:
    
    var fade_in_alpha = 1.0
    if tracking:
        # if in of range,
        radius = global_position.distance_to(tracking.global_position)
        if radius < tracking_distance:
            var fade_in_from = 192.0
            var fade_in_to   = 32.0
            fade_in_alpha = remap(
                radius,
                fade_in_from, fade_in_to,
                0.0, 1.0
            )
            #print(alpha, ", ", radius)
            #var color = Color(1.0, 1.0, 1.0, alpha)  
            #modulate = color
            #$Sprite2DBlack.modulate =color
            #$Sprite2DBlack2.modulate =color
            #$Sprite2DBlack3.modulate =color
            #$Sprite2DBlack4.modulate =color
        else:
            radius = tracking_distance
            fade_in_alpha = 0.0
    else:
        radius = tracking_distance
        modulate = Color(1.0, 1.0, 1.0, 0.0)
    $Sprite2D_gradient.material.set_shader_parameter(
        "radius", radius * 2.0 + 2.0
    )
    $Sprite2D_gradient.material.set_shader_parameter(
        "fade_in_alpha", fade_in_alpha
    )

func die():
    super()
    $Sprite2D_gradient.visible = false

# TODO
# Ice, missile only way to kill
# Invincible to screw attack
# "Attack" capability
# shadow disappear on snap
