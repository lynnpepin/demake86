extends Node2D

var picked: bool = false

func _enter_tree() -> void:
    $AnimatedSprite2D.frame = randi_range(0, 3)
    $AnimatedSprite2D.speed_scale = randf_range(0.25, 4.0)

func pickup():
    if !picked:
        picked = true
        $CPUParticles2D.emitting = true
        $AnimatedSprite2D.visible = false
        $Area2D.set_deferred("monitorable", false)
        $Area2D.set_deferred("monitoring", false)
        var _sfxs = $Sfx.get_children()
        var i1 = randi_range(0, 3)
        var i2 = randi_range(i1, 4)
        var i3 = randi_range(i2, len(_sfxs) -1)
        _sfxs[i1].play()
        _sfxs[i2].play()
        _sfxs[i3].play()
    
func _on_area_2d_area_entered(area: Area2D) -> void:
    
    if area.is_in_group("player"):
        pickup()
