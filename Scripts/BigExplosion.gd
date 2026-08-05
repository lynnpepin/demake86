extends CPUParticles2D


var time = 0
var collision_lifespan = .25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    # BAD BAD HACK TODO 
    # (Relan's death explosion and the missile explosion both use this script)
    # (but I changed the missile to a GPU Particles...)
    if $GPUParticles2D:
        $GPUParticles2D.emitting = true
    else:
        emitting = true
    [$Explode1, $Explode2, $Explode3, $Explode4][randi() % 4].play()
    # HORRIBLE hack, should not do...
    get_parent().shake_player_camera(
        Vector2(randf_range(-3.0, 3.0), 2.0)
    )
    Input.start_joy_vibration(
        0,
        0.25, 1.0, .25
    )
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    time += delta
    pass


func _on_finished() -> void:
    queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
    if area.is_in_group("enemies") and time < collision_lifespan:
        # todo: This should take damage, cooldown, etc.
        area.get_parent().hurt(100, .25)
        print("Missile hit an enemy!")
        # HACKY: 100+ damage required because this is used
        # as a quick way to say "this is a missile, so
        # frozen enemies should explode".
        # this is because i architected missiles wrong
        # when i first made this game
