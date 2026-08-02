extends Node2D

@export var player: Node2D
@export var connected_grave: Node2D
@export var sounds_to_stop_on_death: Array[Node2D]

var is_aware: bool = false
var is_dead: bool = false

func aware():
    if !is_aware and !is_dead:
        is_aware = true
        $Sprite2D_Reagan.flip_h = 1
        $Sprite2D_Reagan.offset.y -= 4
        $Sprite2D_Reagan.offset.x += 3
        # hacky but whatever. shouldnt have set it up like this
        $Sprite2D_Reagan/StaticBody2D.position.x += 3
        $Sprite2D_Reagan/Area2D_hurtbox.position.x += 3
        $AudioStreamPlayer2D_speech.stop()
        $AudioStreamPlayer2D_speech_hpf.stop()


func _on_area_2d_aware_area_entered(area: Area2D) -> void:
    aware()

func dead():
    if !is_dead:
        is_dead = true
        $Sprite2D_Reagan.play("dead")
        $CPUParticles2D_necksplode.emitting = true
        $CPUParticles2D_necksplode.one_shot = true
        # todo stop speech
        $Timer_after_dead_to_activate_grave.start(2.0)
        for sound2d in sounds_to_stop_on_death:
            sound2d.playing = false
            sound2d.stop()

var timer_activations: int = 0

func _on_timer_after_dead_to_activate_grave_timeout() -> void:
    timer_activations += 1
    if timer_activations >= 9:    
        $Timer_after_dead_to_activate_grave.stop()
    if connected_grave:
        # hacky hacky screen shake
        get_parent().get_parent().shake_player_camera(Vector2(0,8.6))
        connected_grave.activate()


func _on_hurtbox_area_2d_area_entered(area: Area2D) -> void:
    dead()
