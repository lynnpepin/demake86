extends EnemyClass

var time: float = 0.0
var radius: float = 128.0
@export var radius_gap: float = 2.0 # for giving more space for visibility

@export var tracking: Node2D
@export var tracking_distance: float = 512.0

@export var prime_distance = 24.0
@export var strike_distance = 12.0


var primed: bool = false
var striked: bool = false
var dead: bool = false

func _ready() -> void:
    $sfx_55.play(randf())
    $sfx_110.play(randf())
    $sfx_220.play(randf())
    $sfx_noise_440.play(randf())
    $sfx_laugh.play(randf())


func _old_physics_process(delta: float) -> void:
    
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
    
func _physics_process(delta: float) -> void:
 
    var fade_in_alpha = 1.0
    if tracking:
        # if in of range,
        radius = global_position.distance_to(tracking.global_position)
        if !frozen:
            if !striked:
                if !primed:
                    if radius <= prime_distance:
                        prime()
                if radius <= strike_distance:
                    strike()
        
        $AnimatedSprite2D.speed_scale = 96.0 / radius
        if radius < tracking_distance:
            var fade_in_from = 192.0
            var fade_in_to   = 16.0
            fade_in_alpha = remap(
                radius,
                fade_in_from, fade_in_to,
                0.0, 1.0
            )
        else:
            radius = tracking_distance
            fade_in_alpha = 0.0
    else:
        radius = tracking_distance
        modulate = Color(1.0, 1.0, 1.0, 0.0)
    $Sprite2D_gradient.material.set_shader_parameter(
        "radius", radius * 2.0 + radius_gap
    )
    $Sprite2D_gradient.material.set_shader_parameter(
        "fade_in_alpha", fade_in_alpha
    )

func freeze(time_to_freeze):
    super(time_to_freeze)
    # set timer to much higher
    freeze_timer = 24.0

func prime():
    $AnimatedSprite2D.play("red_eyes")
    $AnimatedSprite2D.modulate = Color("#ffeedd")
    print("setona prime")
    primed = true

func strike():
    if !dead:
        $AnimatedSprite2D.modulate = Color("#ff8010")
        striked = true
        print("setona strike")
        if tracking:
            tracking.setona_attack()
            striked = false

func die():
    super()
    dead = true
    
    $Sprite2D_gradient.visible = false
    $sfx_55.stop()
    $sfx_110.stop()
    $sfx_220.stop()
    $sfx_noise_440.stop()
    $sfx_laugh.stop()
    $KillParticles.emitting = true

# TODO
# Ice, missile only way to kill
# Invincible to screw attack
# "Attack" capability
# shadow disappear on snap


func _on_missile_hitbox_area_entered(area: Area2D) -> void:
    print("Something is here...")
    if area.is_in_group("explosion"):
        print("... and it's a kablam")
        die()
