extends Node2D

var angel_1_origin: Vector2
var angel_2_origin: Vector2

func activate(time: float = 3.6):
    $angel_1.visible = true
    $angel_2.visible = true
    $Timer.start(time)
    
func deactivate():
    $angel_1.visible = false
    $angel_2.visible = false
    
func _on_timer_timeout() -> void:
    deactivate()
