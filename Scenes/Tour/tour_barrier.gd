extends StaticBody2D

var shattered: bool = false
var destroyed: bool = false

var hp: float = 20.0
var hurt_cooldown: float = 0.0

func _process(delta) -> void:
    hurt_cooldown = max(hurt_cooldown - delta, 0.0)

func hurt(damage, timer):
    #print("zeb blasted:", damage,",", timer)
    if hurt_cooldown <= 0.0:
        print("zeb hurt, new hp:", hp)
        hurt_cooldown = timer
        hp -= damage
        
        if !shattered or !destroyed:
            if hp <= 0.0:
                hp = 20.0
                if !shattered:
                    shatter()
                elif !destroyed:
                    destroy()
        else:
            stop_its_already_dead()
        

func shatter():
    shattered = true
    $AnimatedSprite2D_Glass.play("broken")
    $DripParticles.emitting = true
    $AnimatedSprite2D2_Lava.visible = false
    $BlastLavaParticles_Left.emitting = true
    $BlastLavaParticles_Right.emitting = true
    $BlastGlassParticles_Left.emitting = true
    $BlastGlassParticles_Right.emitting = true
    $DripParticles.emitting = true
    $AnimatedSprite2D_Body.speed_scale += 1.0
    #$GlassParticles.emitting = true
    #$GlassShatter.play()
    $Sfx/Shatter.play()


func destroy():
    destroyed = true
    $BlastLavaParticles_Left.restart()
    $BlastLavaParticles_Right.restart()
    $BlastLavaParticles_Left.emitting = true
    $BlastLavaParticles_Right.emitting = true
    $Area_to_check_for_missiles.set_deferred("monitorable", false)
    $Area_to_check_for_missiles.set_deferred("monitoring", false)
    $CollisionShape2D.set_deferred("disabled", true)
    $AnimatedSprite2D_Body.pause()
    $AnimatedSprite2D_Body.visible = false
    $BlastBodyParticles_Gold.emitting = true
    $BlastBodyParticles_Teal.emitting = true
    $SmokeParticles.emitting = true
    $Sfx/Destroy.play()

func stop_its_already_dead():
    $BlastLavaParticles_Left.restart()
    $BlastLavaParticles_Right.restart()
    $BlastLavaParticles_Left.emitting = true
    $BlastLavaParticles_Right.emitting = true

func get_hit_by_missile():
    print("debug, hit by missle")
    if !shattered:
        shatter()
    elif !destroyed:
        destroy()
    else:
        stop_its_already_dead()

#func _on_area_to_check_for_missiles_area_entered(area: Area2D) -> void:
#    print("bam", area.get_groups())
#    if area.is_in_group("missile"):
#        if !shattered:
#            shatter()
#        elif !destroyed:
#            destroy()
#        else:
#            stop_its_already_dead()
