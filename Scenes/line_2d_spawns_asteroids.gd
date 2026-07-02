extends Line2D


var Asteroid = preload("res://Scenes/asteroid.tscn")

func spawn_asteroid():
    var _r = randf()
    var spawn_at = points[0] * _r + points[1] * (1-_r)
    var asteroid = Asteroid.instantiate()
    asteroid.position = global_position + spawn_at
    add_child(asteroid)

func _on_timer_timeout() -> void:
    spawn_asteroid()
    $Timer.start(randf() * 2.0)
    print("ASTEROID TIMEROUT")
