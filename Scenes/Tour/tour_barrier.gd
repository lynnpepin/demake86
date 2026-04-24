extends StaticBody2D

var shattered: bool = false

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

func destroy():
    $BlastLavaParticles_Left.restart()
    $BlastLavaParticles_Right.restart()
    $BlastLavaParticles_Left.emitting = true
    $BlastLavaParticles_Right.emitting = true
    $Area_to_check_for_missiles.set_deferred("monitorable", false)
    $CollisionShape2D.set_deferred("disabled", true)
    $AnimatedSprite2D_Body.pause()
    $AnimatedSprite2D_Body.visible = false
    $BlastBodyParticles_Gold.emitting = true
    $BlastBodyParticles_Teal.emitting = true
    $SmokeParticles.emitting = true

func _on_area_to_check_for_missiles_area_entered(area: Area2D) -> void:
    if area.is_in_group("missile"):
        if !shattered:
            shatter()
        else:
            destroy()
