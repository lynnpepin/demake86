extends StaticBody2D

var shattered: bool = false
var cracked:   bool = false
var destroyed: bool = false

var hp: float = 20.0
var hurt_cooldown: float = 0.0

var lose_lava_timer  = 0.0
var lose_lava_period = 2.0

func _process(delta) -> void:
    hurt_cooldown = max(hurt_cooldown - delta, 0.0)
    if cracked:
        var perc = lose_lava_timer / lose_lava_period
        lose_lava_timer = min(lose_lava_timer + delta, lose_lava_period)
        $Sprite2D_Lava_Shader.texture.height = 22 - round(10 * perc)
        $Sprite2D_Lava_Shader.position.y = 0 + round(5.5 * perc)


func hurt(damage, timer):
    #print("zeb blasted:", damage,",", timer)
    if hurt_cooldown <= 0.0:
        print("zeb hurt, new hp:", hp)
        hurt_cooldown = timer
        hp -= damage
        
        if !cracked or !shattered:
            if hp <= 0.0:
                hp = 30.0
                if !shattered:
                    shatter()
                elif !destroyed:
                    destroy()

func crack():
    cracked = true
    #$CollisionShape2D_mid.set_deferred("disabled", true)
    $AnimatedSprite2D_Body.play("hurt_1")
    $AnimatedSprite2D_Glass.play("cracked")
    $Sprite2D_Lava_Shader.modulate = Color(1.0, 1.0, 1.0, .75)
    $BlastGooParticles_Right.emitting = true
    $BlastGlassParticles_Right.emitting = true
    $DripGooParticles_Cracked.emitting = true
    pass

func shatter():
    pass
    # once shattered, she can be urt with beams

func destroy():
    pass

func get_hit_by_missile():
    print("debug, thatch hit by missle")
    if !cracked:
        crack()

func _on_area_to_check_for_bombs_area_entered(area: Area2D) -> void:
    print("bam")
    if area.is_in_group("missile"):
        print(area.get_parent())
        if !cracked:
            crack()
