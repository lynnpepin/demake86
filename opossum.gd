extends AnimatedSprite2D


var panic = false
var dead = false
var timer = 0.0

func _process(delta: float) -> void:
    if panic and !dead:
        timer += delta
        if timer >= .5:
            timer -= .5
            flip_h = !flip_h
            
func _on_area_2d_player_near_area_entered(area: Area2D) -> void:
    if area.is_in_group("player") and !dead:
        print(":V")
        play("panic")
        panic = true


func _on_area_2d_player_too_near_area_entered(area: Area2D) -> void:
    if area.is_in_group("player"):
        print("x_x")
        play("dead")
        panic = false
        dead = true
