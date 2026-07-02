extends Line2D


func spawn_asteroid():
    var _r = randf()
    var spawn_at = points[0] * _r + points[1] * (1-_r)
    # todo
