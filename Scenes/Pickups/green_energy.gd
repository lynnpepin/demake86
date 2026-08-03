extends Node2D

var picked: bool = false

# Three randomly selected sounds
# initialized here so we can put them into `_enter_tree` or `_ready` depending on performance characteristics
var selected_sound_i1: int
var selected_sound_i2: int
var selected_sound_i3: int

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
        
        selected_sound_i1 = randi_range(0, 3)
        selected_sound_i2 = randi_range(selected_sound_i1, 4)
        selected_sound_i3 = randi_range(selected_sound_i2, len(_sfxs) -1)
        _sfxs[selected_sound_i1].play()
        _sfxs[selected_sound_i2].play()
        _sfxs[selected_sound_i3].play()
    
func _on_area_2d_area_entered(area: Area2D) -> void:
    
    if area.is_in_group("player"):
        pickup()
