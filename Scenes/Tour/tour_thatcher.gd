extends StaticBody2D

var shattered: bool = false
var cracked:   bool = false
var destroyed: bool = false

var hp: float = 100.0
var maxhp: float = 100.0
var hurt_cooldown: float = 0.0

var lose_lava_timer  = 0.0
var lose_lava_period = 2.0

func _process(delta) -> void:
    hurt_cooldown = clamp(hurt_cooldown - delta, 0.0, 64.0)
    if cracked and !shattered:
        var perc = lose_lava_timer / lose_lava_period
        lose_lava_timer = min(lose_lava_timer + delta, lose_lava_period)
        $Sprite2D_Lava_Shader.texture.height = 22 - round(10 * perc)
        $Sprite2D_Lava_Shader.position.y = 0 + round(5.5 * perc)
    
    elif shattered and !destroyed:
        var perc = lose_lava_timer / lose_lava_period
        lose_lava_timer = min(lose_lava_timer + delta, lose_lava_period)
        $Sprite2D_Lava_Shader.texture.height = 22 - round(10 * perc)
        $Sprite2D_Lava_Shader.position.y = 0 + round(5.5 * perc)

func hurt(damage, timer):
    if hurt_cooldown <= 0.0:
        print("thatch blasted for", damage,", cooldown ", timer)
        hurt_cooldown = timer
        hp = max(hp - damage, 0.0)
        
        if !cracked or !shattered:
            if hp <= 0.0:
                if !cracked:
                    crack()
                    hp = 40.0
                elif !shattered:
                    shatter()
                    hp = 100.0
        if cracked and shattered and !destroyed:
            $AnimatedSprite2D_Body.modulate = Color(
                1.0, .5 + hp / (2.0 * maxhp), .5 + hp / (2.0 * maxhp)
            )
            if hp <= 60.0:
                $AnimatedSprite2D_Body.play("hurt_3")
            if hp <= 0.0:
                destroy()

func crack():
    print("CRACKED THATCHER")
    cracked = true
    #$CollisionShape2D_mid.set_deferred("disabled", true)
    $AnimatedSprite2D_Body.play("hurt_1")
    $AnimatedSprite2D_Glass.play("cracked")
    $Sprite2D_Lava_Shader.modulate = Color(1.0, 1.0, 1.0, .75)
    $BlastGooParticles_Right.emitting = true
    $BlastGlassParticles_Right.emitting = true
    $DripGooParticles_Cracked.emitting = true
    $DripGooParticles_Cracked.preprocess = 1.0
    pass

func shatter():
    print("SHATTERED THATCHER")
    shattered = true
    $Sprite2D_Lava_Shader.modulate = Color(1.0, 1.0, 1.0, 0.0)
    $AnimatedSprite2D_Body.play("hurt_2")
    $AnimatedSprite2D_Glass.play("shattered")
    $BlastGooParticles_Right.emitting = true
    $BlastGlassParticles_Right.emitting = true
    $DripGooParticles_Cracked.emitting = false
    $DripGooParticles_Shattered.emitting = true
    $DripGooParticles_Shattered.preprocess = 1.0
    $CollisionShape2D_mid.set_deferred("disabled", true)
    $Area_to_check_for_bombs.set_deferred("monitoring", false)
    hp = 100.0
    # once shattered, she can be urt with beams

func destroy():
    print("DESTROYED THATCHER")
    destroyed = true
    $AnimatedSprite2D_Body.play("dead")
    $AnimatedSprite2D_Glass.play("destroyed")
    $BlastGooParticles_Right.emitting = true
    $BlastGlassParticles_Right.emitting = true
    
    $DripGooParticles_Shattered.emitting = false
    $DripGooParticles_Destroyed.emitting = true
    $DripGooParticles_Destroyed.preprocess = .5
    $Area2D_to_hit_Thatcher.set_deferred("monitoring", false)
    $CollisionShape2D_top.set_deferred("disabled", true)
    $CollisionShape2D_bottom.set_deferred("disabled", true)
    $CollisionShape2D_back.set_deferred("disabled", true)
    
    # todo - sound effect, timer
    get_parent().tourian_activate_escape_layout()

func get_hit_by_missile():
    print("debug, thatch hit by missle", cracked, shatter)
    if !cracked:
        crack()
    elif !shattered:
        shatter()


func _on_area_2d_to_hit_thatcher_body_entered(body: Node2D) -> void:
    if shattered and cracked and !destroyed:
        print("BEAM ENTERED; ", body.get_groups(), "; hp = ", hp)
        if body.is_in_group("missile"):
            body.die()
            destroy()
        elif body.is_in_group("beam"):
            body.die()
            hurt(body.damage, .25)
        elif body.is_in_group("explosion"):
            hurt(4.0, .25)


# TODO:
# - shake on hit
# - sfx on hit
# - glass shatter, goo, etc. sound effects as she is damaged
