extends Node2D

@export var connected_grave: Node2D
@export var root: Node2D

var tolls: int = 0

func _on_area_2d_eyes_hurtbox_area_entered(area: Area2D) -> void:
    $AnimationPlayer.play("retreat!", 4, 1)
    $MainBody/Eyes.visible = false
    
    if tolls < 6:
        $Timer.start(1.5)
    


func _on_bell_toll_timer_timeout() -> void:
    tolls += 1
    if connected_grave:
        connected_grave.activate()
    if root:
        root.shake_player_camera(Vector2(tolls,0.0))
        $Timer.start(1.5)
