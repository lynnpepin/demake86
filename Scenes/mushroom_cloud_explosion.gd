extends Node2D


var timer = 0.0
var ring_after = 0.1875
var free_after = 4.0

var ring_on = false
var hurt_off_after = .875

func _ready():
    $AudioStreamPlayer2D.play()
    $Particles_Cloud.emitting = true
    
func _process(delta):
    timer += delta
    if timer > hurt_off_after:
        #$hurtbox.set_deferred("monitoring", false)
        if $hurtbox:
            $hurtbox.queue_free()
        
    if timer > free_after:
        queue_free()
    if !ring_on:
        if timer > ring_after:
            ring_on = true
            $hurtbox.set_deferred("monitoring", true)
            $Particles_Ring.emitting = true
    

func _on_area_entered(area: Area2D) -> void:
    if area.is_in_group("player"):
        area.get_parent().hurt(
            2.0,
            .5
        )
